from flask import Blueprint, render_template, request, redirect, url_for, flash
from app import db
from app.models import User, Project, Bid, Review, Payment,Message,Portfolio,ProjectFile,Deliverable,WithdrawRequest,AdminWithdraw,Notification
from flask_login import login_user, logout_user, login_required, current_user
from flask import send_from_directory
import os
import bcrypt
from datetime import datetime
from flask import current_app
from flask import request, render_template,redirect,url_for
from sqlalchemy import or_
from sqlalchemy import func


import razorpay

main = Blueprint('main', __name__)

def create_notification(user_id, title, message, link=None):
    n = Notification(
        user_id=user_id,
        title=title,
        message=message,
        link=link
    )
    db.session.add(n)
    db.session.commit()

# ======================
# HOME ROUTE
# ======================

@main.route("/")
def home():

    # ================= PLATFORM STATS =================

    total_projects = Project.query.count()

    total_users = User.query.filter(
        User.is_active == True
    ).count()

    completed_projects = Project.query.filter_by(
        status="completed"
    ).count()


    # ================= RECENT OPEN PROJECTS =================
    # Only active clients' projects

    recent_projects = Project.query.join(User).filter(
        Project.status == "open",
        User.is_active == True
    ).order_by(Project.id.desc()).limit(6).all()


    # ================= PROJECT CATEGORIES =================

    # PROJECT CATEGORIES WITH COUNT
    categories = db.session.query(
    Project.category,
    func.count(Project.id)
).filter(
    Project.category != None
).group_by(
    Project.category
).all()


    # ================= TOP DEVELOPERS =================

    top_developers = User.query.filter(
        User.role == "developer",
        User.is_active == True
    ).order_by(User.id.desc()).limit(4).all()


    return render_template(
        "index.html",
        total_projects=total_projects,
        total_users=total_users,
        completed_projects=completed_projects,
        recent_projects=recent_projects,
        categories=categories,
        top_developers=top_developers
    )

# ======================
# REGISTER
# ======================

@main.route('/register', methods=['GET', 'POST'])
def register():

    if request.method == 'POST':

        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        role = request.form['role']

        existing_user = User.query.filter_by(email=email).first()

        if existing_user:
            flash("Email already registered!")
            return redirect(url_for('main.register'))

        hashed_pw = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

        user = User(
            name=name,
            email=email,
            password=hashed_pw,
            role=role
        )

        db.session.add(user)
        db.session.commit()

        flash("Registration Successful! Please Login.")
        return redirect(url_for('main.login'))

    return render_template('register.html')


# ======================
# LOGIN
# ======================

@main.route('/login', methods=['GET','POST'])
def login():

    if request.method == 'POST':

        email = request.form.get('email')
        password = request.form.get('password')

        user = User.query.filter_by(email=email).first()

        if user:

            # 🔴 Check if account is deactivated
            if not user.is_active:
                flash("Your account has been deactivated. Please contact admin.")
                return redirect(url_for('main.login'))

            # 🔐 Password check
            if bcrypt.checkpw(password.encode('utf-8'), user.password):

                login_user(user)

                # Redirect based on role
                if user.role == "client":
                    return redirect(url_for('main.client_dashboard'))

                elif user.role == "developer":
                    return redirect(url_for('main.developer_dashboard'))

                elif user.role == "admin":
                    return redirect(url_for('main.admin_dashboard'))

        flash("Invalid email or password")

    return render_template("login.html")
# ======================
# LOGOUT
# ======================

@main.route('/logout')
@login_required
def logout():

    logout_user()
    return redirect(url_for('main.login'))


# ======================
# CLIENT DASHBOARD
# ======================

@main.route('/client/dashboard')
@login_required
def client_dashboard():

    if current_user.role != "client":
        return "Unauthorized Access", 403

    projects = Project.query.filter_by(client_id=current_user.id).all()

    return render_template('dashboard_client.html', projects=projects)


# ======================
# ======================
# DEVELOPER DASHBOARD
# ======================

@main.route('/developer/dashboard')
@login_required
def developer_dashboard():

    if current_user.role != "developer":
        return "Unauthorized", 403

    # ================= AVAILABLE PROJECTS =================
    available_projects = Project.query.join(User).filter(
    Project.status == "open",
    User.is_active == True
).all()

    # ================= MY BIDS =================
    my_bids = Bid.query.filter_by(developer_id=current_user.id).all()

    # ================= ACTIVE PROJECTS =================
    active_projects = Project.query.join(Bid).join(User).filter(
    Bid.developer_id == current_user.id,
    Bid.status == "accepted",
    Project.status == "in_progress",
    User.is_active == True
).all()

    # ================= COMPLETED PROJECTS =================
    completed_projects = Project.query.join(Bid).filter(
        Bid.project_id == Project.id,
        Bid.developer_id == current_user.id,
        Bid.status == "accepted",
        Project.status == "completed"
    ).all()

    # ================= PORTFOLIO =================
    portfolios = Portfolio.query.filter_by(
        developer_id=current_user.id
    ).all()

    # ================= PAYMENTS =================
    payments = Payment.query.filter_by(
        developer_id=current_user.id
    ).all()

    total_earnings = sum(p.developer_amount or 0 for p in payments)

    # ================= WITHDRAW REQUESTS =================
    withdraw_requests = WithdrawRequest.query.filter_by(
        user_id=current_user.id
    ).all()

    # completed withdraw
    withdrawn = sum(w.amount or 0 for w in withdraw_requests if w.status == "completed")

    # available balance
    balance = total_earnings - withdrawn

    # ================= RENDER =================
    return render_template(
        "dashboard_developer.html",
        available_projects=available_projects,
        my_bids=my_bids,
        active_projects=active_projects,
        completed_projects=completed_projects,
        portfolios=portfolios,
        payments=payments,
        withdraw_requests=withdraw_requests,
        total_earnings=total_earnings,
        withdrawn=withdrawn,
        balance=balance
    )
# ======================
# CREATE PROJECT
# ======================

@main.route('/create-project', methods=['POST'])
@login_required
def create_project():

    title = request.form['title']
    description = request.form['description']
    budget = request.form['budget']
    category = request.form.get('category')
    custom_category = request.form.get('custom_category')
    deadline = request.form['deadline']

    # if user selected "Other"
    if category == "Other" and custom_category:
        category = custom_category

    project = Project(
        title=title,
        description=description,
        budget=budget,
        category=category,
        deadline=deadline,
        client_id=current_user.id
    )

    db.session.add(project)
    db.session.commit()

    flash("Project created successfully")

    return redirect(url_for('main.client_dashboard'))
# ======================
# SUBMIT BID
# ======================

# ======================
# SUBMIT BID
# ======================

@main.route('/submit-bid/<int:project_id>', methods=['POST'])
@login_required
def submit_bid(project_id):

    # ✅ developer + admin allowed
    if current_user.role not in ["developer", "admin"]:
        flash("Only developers and admin can place bids.")
        return redirect(url_for('main.home'))

    project = Project.query.get_or_404(project_id)

    # ❌ client cannot bid on own project
    if project.client_id == current_user.id:
        flash("You cannot bid on your own project.")
        return redirect(url_for('main.home'))

    # ❌ duplicate bid check
    existing_bid = Bid.query.filter_by(
        project_id=project_id,
        developer_id=current_user.id
    ).first()

    if existing_bid:
        flash("You already submitted a bid for this project.")
        return redirect(url_for('main.project_details', project_id=project_id))

    try:
        bid_amount = request.form.get('bid_amount')
        proposal = request.form.get('proposal')

        # ✅ validation
        if not bid_amount or not proposal:
            flash("All fields are required.")
            return redirect(url_for('main.project_details', project_id=project_id))

        bid_amount = int(bid_amount)

        if bid_amount <= 0:
            flash("Invalid bid amount.")
            return redirect(url_for('main.project_details', project_id=project_id))

        # ================= CREATE BID =================
        bid = Bid(
            bid_amount=bid_amount,
            proposal=proposal,
            project_id=project_id,
            developer_id=current_user.id,
            status="pending"
        )

        db.session.add(bid)
        db.session.commit()

        # 🔔 NOTIFICATION TO CLIENT
        create_notification(
            user_id=project.client_id,
            title="New Bid",
            message=f"{current_user.name} placed a bid on your project",
            link=url_for('main.project_details', project_id=project_id)
        )

        flash("✅ Bid submitted successfully!")

    except Exception as e:
        db.session.rollback()
        print("BID ERROR:", e)  # debug के लिए
        flash("❌ Error submitting bid.")

    # ✅ redirect better UX
    return redirect(url_for('main.project_details', project_id=project_id))

# ======================
# EDIT BID (POST)
# ======================

@main.route('/edit-bid/<int:project_id>', methods=['POST'])
@login_required
def edit_bid(project_id):

    # ✅ developer + admin allowed
    if current_user.role not in ["developer", "admin"]:
        flash("Unauthorized access.")
        return redirect(url_for('main.home'))

    bid = Bid.query.filter_by(
        project_id=project_id,
        developer_id=current_user.id
    ).first()

    if not bid:
        flash("Bid not found")
        return redirect(url_for('main.developer_dashboard'))

    # ❌ accepted bid edit block
    if bid.status == "accepted":
        flash("You cannot edit an accepted bid.")
        return redirect(url_for('main.developer_dashboard'))

    try:
        bid_amount = request.form.get('bid_amount')
        proposal = request.form.get('proposal')

        if not bid_amount or not proposal:
            flash("All fields required")
            return redirect(url_for('main.edit_bid_page', project_id=project_id))

        bid.bid_amount = int(bid_amount)
        bid.proposal = proposal

        db.session.commit()

        # 🔔 notify client
        create_notification(
            user_id=bid.project.client_id,
            title="Bid Updated",
            message=f"{current_user.name} updated their bid",
            link=url_for('main.project_details', project_id=project_id)
        )

        flash("✅ Bid updated successfully")

    except Exception as e:
        db.session.rollback()
        print("EDIT BID ERROR:", e)
        flash("❌ Error updating bid")

    return redirect(url_for('main.developer_dashboard'))
# ======================
# EDIT BID PAGE
# ======================

@main.route('/edit-bid-page/<int:project_id>')
@login_required
def edit_bid_page(project_id):

    if current_user.role not in ["developer", "admin"]:
        flash("Unauthorized access.")
        return redirect(url_for('main.home'))

    bid = Bid.query.filter_by(
        project_id=project_id,
        developer_id=current_user.id
    ).first_or_404()

    return render_template("edit_bid.html", bid=bid)
# ACCEPT BID
# ======================

@main.route('/accept-bid/<int:bid_id>')
@login_required
def accept_bid(bid_id):

    if current_user.role != "client":
        return "Unauthorized Access", 403

    bid = Bid.query.get_or_404(bid_id)
    project = bid.project

    if project.client_id != current_user.id:
        return "Unauthorized Action", 403

    # ✅ already accepted check
    if bid.status == "accepted":
        flash("Already accepted")
        return redirect(url_for('main.client_dashboard'))

    project.status = "in_progress"
    bid.status = "accepted"

    # ❌ reject others
    other_bids = Bid.query.filter(
        Bid.project_id == project.id,
        Bid.id != bid.id
    ).all()

    for other in other_bids:
        other.status = "rejected"

    db.session.commit()

    # 🔔 notify developer
    create_notification(
        user_id=bid.developer_id,
        title="Bid Accepted 🎉",
        message="Your bid has been accepted",
        link=url_for('main.chat', project_id=project.id, user_id=project.client_id)
    )

    flash("✅ Bid Accepted! Project started.")
    return redirect(url_for('main.client_dashboard'))


# submit work by developer

@main.route('/submit-work/<int:project_id>', methods=['GET','POST'])
@login_required
def submit_work(project_id):

    project = Project.query.get_or_404(project_id)

    # ✅ only assigned developer allowed
    bid = Bid.query.filter_by(
        project_id=project_id,
        developer_id=current_user.id,
        status="accepted"
    ).first()

    if not bid:
        return "Unauthorized", 403

    if request.method == "POST":

        file = request.files.get('file')
        github = request.form.get('github')
        live = request.form.get('live')
        notes = request.form.get('notes')

        filename = None

        if file and file.filename:
            filename = secure_filename(file.filename)
            file.save("uploads/" + filename)

        d = Deliverable(
            project_id=project.id,
            developer_id=current_user.id,
            file=filename,
            github_link=github,
            live_link=live,
            notes=notes
        )

        db.session.add(d)

        project.status = "submitted"

        db.session.commit()

        # 🔔 notify client
        create_notification(
            user_id=project.client_id,
            title="Work Submitted",
            message="Developer submitted the project work",
            link=url_for('main.project_details', project_id=project.id)
        )

        flash("✅ Work submitted successfully")

        return redirect(url_for('main.developer_dashboard'))

    return render_template("submit_work.html", project=project)

@main.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(
        UPLOAD_FOLDER,
        filename
    )

@main.route('/review-work/<int:project_id>')
@login_required
def review_work(project_id):

    if current_user.role != "client":
        return "Unauthorized", 403

    project = Project.query.get_or_404(project_id)

    # ensure client owns project
    if project.client_id != current_user.id:
        return "Unauthorized", 403

    deliverables = Deliverable.query.filter_by(
        project_id=project.id
    ).all()

    return render_template(
        "review_work.html",
        project=project,
        deliverables=deliverables
    )

# ======================
# COMPLETE PROJECT + PAYMENT
# ======================
@main.route('/complete-project/<int:project_id>')
@login_required
def complete_project(project_id):

    if current_user.role != "client":
        return "Unauthorized Access", 403

    project = Project.query.get_or_404(project_id)

    if project.client_id != current_user.id:
        return "Unauthorized Action", 403

    # ✅ only allow if submitted
    if project.status not in ["in_progress", "submitted"]:
        flash("Project cannot be completed yet.")
        return redirect(url_for('main.client_dashboard'))

    # ❌ already completed check
    if project.status == "completed":
        flash("Project already completed.")
        return redirect(url_for('main.client_dashboard'))

    project.status = "completed"

    accepted_bid = Bid.query.filter_by(
        project_id=project.id,
        status="accepted"
    ).first()

    if accepted_bid:

        total = project.budget
        commission = int(total * 0.10)
        developer_amount = total - commission

        payment = Payment(
            project_id=project.id,
            client_id=current_user.id,
            developer_id=accepted_bid.developer_id,
            amount=total,
            platform_fee=commission,
            developer_amount=developer_amount,
            method="cash",
            status="completed"
        )

        db.session.add(payment)

        # 🔔 notify developer
        create_notification(
            user_id=accepted_bid.developer_id,
            title="Payment Received 💰",
            message=f"You received ₹{developer_amount} for project",
            link=url_for('main.developer_dashboard')
        )

    db.session.commit()

    flash("✅ Project Completed & Payment Done!")
    return redirect(url_for('main.client_dashboard'))





# ======================
# SUBMIT REVIEW
# ======================

@main.route('/submit-review/<int:project_id>', methods=['POST'])
@login_required
def submit_review(project_id):

    if current_user.role != "client":
        return "Unauthorized Access", 403

    project = Project.query.get_or_404(project_id)

    if project.client_id != current_user.id:
        return "Unauthorized Action", 403

    if project.status != "completed":
        flash("Project must be completed before review.")
        return redirect(url_for('main.client_dashboard'))

    # ✅ duplicate review block
    existing = Review.query.filter_by(
        project_id=project.id,
        client_id=current_user.id
    ).first()

    if existing:
        flash("You already submitted review.")
        return redirect(url_for('main.client_dashboard'))

    accepted_bid = Bid.query.filter_by(
        project_id=project.id,
        status="accepted"
    ).first()

    if not accepted_bid:
        flash("No accepted developer found.")
        return redirect(url_for('main.client_dashboard'))

    try:
        rating = int(request.form['rating'])
        comment = request.form['comment']

        if rating < 1 or rating > 5:
            flash("Invalid rating")
            return redirect(url_for('main.client_dashboard'))

        review = Review(
            rating=rating,
            comment=comment,
            project_id=project.id,
            client_id=current_user.id,
            developer_id=accepted_bid.developer_id
        )

        db.session.add(review)
        db.session.commit()

        # 🔔 notification
        create_notification(
            user_id=accepted_bid.developer_id,
            title="New Review ⭐",
            message=f"You received {rating} star rating",
            link=url_for('main.developer_dashboard')
        )

        flash("⭐ Review Submitted Successfully!")

    except Exception as e:
        db.session.rollback()
        print("REVIEW ERROR:", e)
        flash("Error submitting review")

    return redirect(url_for('main.client_dashboard'))
# ======================
# UPDATE PROFILE
# ======================

@main.route('/update-profile', methods=['POST'])
@login_required
def update_profile():

    name = request.form.get('name')
    email = request.form.get('email')

    existing_user = User.query.filter_by(email=email).first()

    if existing_user and existing_user.id != current_user.id:
        flash("Email already in use")
        return redirect(url_for('main.home'))

    current_user.name = name
    current_user.email = email

    if current_user.role == "developer":

        current_user.skills = request.form.get('skills')
        current_user.portfolio = request.form.get('portfolio')
        current_user.bio = request.form.get('bio')
        current_user.github = request.form.get('github')

    db.session.commit()

    flash("Profile Updated Successfully")

    return redirect(url_for('main.home'))

# ======================
# CHANGE PASSWORD
# ======================

@main.route('/change-password', methods=['POST'])
@login_required
def change_password():

    old_password = request.form.get('old_password')
    new_password = request.form.get('new_password')

    if not bcrypt.checkpw(old_password.encode('utf-8'), current_user.password):

        flash("Old password incorrect")
        return redirect(url_for('main.home'))

    hashed_pw = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())

    current_user.password = hashed_pw

    db.session.commit()

    flash("Password Updated Successfully")

    return redirect(url_for('main.home'))

@main.route('/project/<int:project_id>')
def project_details(project_id):

    project = Project.query.get_or_404(project_id)

    bids = Bid.query.filter_by(project_id=project_id).all()

    return render_template(
        "project_details.html",
        project=project,
        bids=bids
    )
    
@main.route('/developer/<int:user_id>')
def developer_profile(user_id):

    developer = User.query.get_or_404(user_id)

    # ✅ Portfolio
    portfolios = Portfolio.query.filter_by(
        developer_id=user_id
    ).all()

    # ✅ Accepted projects only (important fix)
    completed_projects = Project.query.join(Bid).filter(
        Bid.developer_id == user_id,
        Bid.status == "accepted",
        Project.status == "completed"
    ).all()

    projects_completed = len(completed_projects)

    # ✅ Reviews
    reviews = Review.query.filter_by(
        developer_id=user_id
    ).order_by(Review.id.desc()).all()

    # ✅ Total earnings
    payments = Payment.query.filter_by(
        developer_id=user_id
    ).all()

    total_earnings = sum((p.developer_amount or 0) for p in payments)

    return render_template(
        "developer_profile.html",
        developer=developer,
        portfolios=portfolios,
        projects_completed=projects_completed,
        reviews=reviews,
        total_earnings=total_earnings
    )
    
@main.route('/admin')
@login_required
def admin_dashboard():

    if current_user.role != "admin":
        return "Unauthorized", 403

    # USERS
    total_users = User.query.count()
    total_developers = User.query.filter_by(role="developer").count()
    total_clients = User.query.filter_by(role="client").count()

    # PROJECTS
    total_projects = Project.query.count()
    completed_projects = Project.query.filter_by(status="completed").count()
    active_projects = Project.query.filter_by(status="in_progress").count()
    pending_projects = Project.query.filter_by(status="open").count()

    # PAYMENTS
    payments = Payment.query.all()

    # PLATFORM REVENUE
    total_revenue = sum((p.platform_fee or 0) for p in payments)

    # ADMIN WITHDRAW HISTORY
    admin_withdraws = AdminWithdraw.query.all()

    total_withdrawn = sum((w.amount or 0) for w in admin_withdraws)

    # AVAILABLE BALANCE
    balance = total_revenue - total_withdrawn

    # TABLE DATA
    users = User.query.all()
    projects = Project.query.all()

    # DEVELOPER WITHDRAW REQUESTS
    withdraw_requests = WithdrawRequest.query.order_by(
        WithdrawRequest.id.desc()
    ).all()

    return render_template(
        "admin_dashboard.html",

        # USER STATS
        total_users=total_users,
        total_developers=total_developers,
        total_clients=total_clients,

        # PROJECT STATS
        total_projects=total_projects,
        active_projects=active_projects,
        completed_projects=completed_projects,
        pending_projects=pending_projects,

        # FINANCE
        total_revenue=total_revenue,
        total_withdrawn=total_withdrawn,
        balance=balance,

        # TABLE DATA
        users=users,
        projects=projects,
        payments=payments,
        withdraw_requests=withdraw_requests,
        admin_withdraws=admin_withdraws
    )
@main.route('/chat/<int:project_id>/<int:user_id>', methods=['GET','POST'])
@login_required
def chat(project_id, user_id):

    project = Project.query.get_or_404(project_id)

    # ✅ Only allow if project is in progress
    bid = Bid.query.filter_by(
        project_id=project_id,
        status="accepted"
    ).first()

    if not bid:
        return "Chat not allowed", 403

    # ✅ Only client & selected developer allowed
    if current_user.id not in [project.client_id, bid.developer_id]:
        return "Unauthorized", 403

    # ================= SEND MESSAGE =================
    if request.method == "POST":

        msg = request.form.get('message')

        if not msg:
            flash("Message cannot be empty")
            return redirect(request.url)

        message = Message(
            sender_id=current_user.id,
            receiver_id=user_id,
            project_id=project_id,
            message=msg
        )

        db.session.add(message)
        db.session.commit()

        # 🔔 NOTIFICATION
        create_notification(
            user_id=user_id,
            title="New Message",
            message=f"{current_user.name} sent you a message",
            link=url_for('main.chat', project_id=project_id, user_id=current_user.id)
        )

        return redirect(url_for('main.chat', project_id=project_id, user_id=user_id))

    # ================= LOAD MESSAGES =================
    messages = Message.query.filter_by(
        project_id=project_id
    ).order_by(Message.id.asc()).all()

    return render_template(
        "chat.html",
        messages=messages,
        project=project,
        user_id=user_id
    )
@main.route('/admin/delete-user/<int:user_id>')
@login_required
def delete_user(user_id):

    if current_user.role != "admin":
        return "Unauthorized",403

    user = User.query.get_or_404(user_id)

    db.session.delete(user)
    db.session.commit()

    flash("User Deleted Successfully")

    return redirect(url_for('main.admin_dashboard'))

@main.route('/admin/delete-project/<int:project_id>')
@login_required
def delete_project(project_id):

    if current_user.role != "admin":
        return "Unauthorized",403

    project = Project.query.get_or_404(project_id)

    db.session.delete(project)
    db.session.commit()

    flash("Project Deleted Successfully")

    return redirect(url_for('main.admin_dashboard'))

# ======================
# ADD PORTFOLIO
# ======================

@main.route('/portfolio/add', methods=['GET','POST'])
@login_required
def add_portfolio():

    if current_user.role != "developer":
        flash("Only developers can add portfolio projects.")
        return redirect(url_for('main.home'))

    if request.method == "POST":

        title = request.form.get('title')
        description = request.form.get('description')
        link = request.form.get('link')

        if not title or not description or not link:
            flash("All fields are required")
            return redirect(url_for('main.add_portfolio'))

        new_portfolio = Portfolio(
            developer_id=current_user.id,
            title=title,
            description=description,
            link=link
        )

        db.session.add(new_portfolio)
        db.session.commit()

        flash("Portfolio added successfully!")

        return redirect(url_for('main.developer_dashboard'))

    return render_template("add_portfolio.html")

import os
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "uploads"


@main.route('/upload/<int:project_id>', methods=['POST'])
@login_required
def upload_file(project_id):

    file = request.files['file']

    filename = secure_filename(file.filename)

    file.save(os.path.join(UPLOAD_FOLDER, filename))

    pf = ProjectFile(
        project_id=project_id,
        filename=filename
    )

    db.session.add(pf)
    db.session.commit()

    flash("File uploaded")

    return redirect(url_for('main.project_details', project_id=project_id))

# ======================
# DELETE PORTFOLIO
# ======================

@main.route('/portfolio/delete/<int:portfolio_id>')
@login_required
def delete_portfolio(portfolio_id):

    portfolio = Portfolio.query.get_or_404(portfolio_id)

    if portfolio.developer_id != current_user.id:
        return "Unauthorized",403

    db.session.delete(portfolio)
    db.session.commit()

    flash("Portfolio Deleted Successfully")

    return redirect(url_for('main.developer_dashboard'))

# ======================
# EDIT PORTFOLIO
# ======================

@main.route('/portfolio/edit/<int:portfolio_id>', methods=['GET','POST'])
@login_required
def edit_portfolio(portfolio_id):

    portfolio = Portfolio.query.get_or_404(portfolio_id)

    if portfolio.developer_id != current_user.id:
        return "Unauthorized",403

    if request.method == "POST":

        portfolio.title = request.form.get("title")
        portfolio.description = request.form.get("description")
        portfolio.link = request.form.get("link")

        db.session.commit()

        flash("Portfolio Updated Successfully")

        return redirect(url_for('main.developer_dashboard'))

    return render_template(
        "edit_portfolio.html",
        portfolio=portfolio
    )
    
@main.route('/reject-bid/<int:bid_id>')
@login_required
def reject_bid(bid_id):

    bid = Bid.query.get_or_404(bid_id)

    project = bid.project

    if project.client_id != current_user.id:
        return "Unauthorized",403

    bid.status = "rejected"

    db.session.commit()

    flash("Bid rejected")

    return redirect(url_for('main.client_dashboard'))

@main.route('/payment-options/<int:project_id>')
@login_required
def payment_options(project_id):

    project = Project.query.get_or_404(project_id)

    bid = Bid.query.filter_by(
        project_id=project.id,
        status="accepted"
    ).first()

    developer = bid.developer

    commission = int(project.budget * 0.10)

    developer_amount = project.budget - commission

    return render_template(
        "payment_options.html",
        project=project,
        developer=developer,
        commission=commission,
        developer_amount=developer_amount
    )
    
@main.route('/cash-payment/<int:project_id>')
@login_required
def cash_payment(project_id):

    project = Project.query.get_or_404(project_id)

    bid = Bid.query.filter_by(
        project_id=project.id,
        status="accepted"
    ).first()

    commission = int(project.budget * 0.10)

    developer_amount = project.budget - commission

    payment = Payment(

        project_id=project.id,

        client_id=current_user.id,

        developer_id=bid.developer_id,

        amount=project.budget,

        platform_fee=commission,

        developer_amount=developer_amount,

        method="cash",

        status="completed"
    )

    db.session.add(payment)
    db.session.commit()

    flash("Payment recorded successfully")

    return redirect(url_for('main.client_dashboard'))

@main.route('/razorpay-payment/<int:project_id>')
@login_required
def razorpay_payment(project_id):

    project = Project.query.get_or_404(project_id)

    # CONFIG se key aur secret lena
    key = current_app.config["RAZORPAY_KEY_ID"]
    secret = current_app.config["RAZORPAY_SECRET"]

    # Razorpay client
    client = razorpay.Client(auth=(key, secret))

    amount = project.budget * 100

    return render_template(
        "razorpay_payment.html",
        project=project,
        amount=amount,
        razorpay_key=key
    )

@main.route('/payment-success/<int:project_id>')
@login_required
def payment_success(project_id):

    project = Project.query.get_or_404(project_id)

    flash("Payment Successful!", "success")

    return redirect(url_for('main.client_dashboard'))


@main.route('/withdraw', methods=['GET','POST'])
@login_required
def withdraw():

    if current_user.role != "developer":
        return "Unauthorized",403

    payments = Payment.query.filter_by(
        developer_id=current_user.id
    ).all()

    total = sum((p.developer_amount or 0) for p in payments)

    withdraws = WithdrawRequest.query.filter_by(
        user_id=current_user.id,
        status="completed"
    ).all()

    withdrawn = sum((w.amount or 0) for w in withdraws)

    balance = total - withdrawn

    if request.method == "POST":

        try:
            amount = int(request.form['amount'])
            method = request.form['method']
            details = request.form['details']

            if amount <= 0:
                flash("Invalid amount")
                return redirect(url_for('main.withdraw'))

            if amount > balance:
                flash("Insufficient Balance")
                return redirect(url_for('main.withdraw'))

            req = WithdrawRequest(
                user_id=current_user.id,
                amount=amount,
                method=method,
                details=details,
                status="pending"
            )

            db.session.add(req)
            db.session.commit()

            # 🔔 notify admin
            admin = User.query.filter_by(role="admin").first()

            if admin:
                create_notification(
                    user_id=admin.id,
                    title="Withdraw Request",
                    message=f"{current_user.name} requested ₹{amount}",
                    link=url_for('main.admin_withdraw_requests')
                )

            flash("✅ Withdraw Request Sent")

        except Exception as e:
            db.session.rollback()
            print("WITHDRAW ERROR:", e)
            flash("❌ Error processing request")

        return redirect(url_for('main.developer_dashboard'))

    return render_template("withdraw.html", balance=balance)
    
# ======================
# ADMIN WITHDRAW REQUESTS
# ======================

@main.route('/admin/withdraw-requests')
@login_required
def admin_withdraw_requests():

    if current_user.role != "admin":
        return "Unauthorized", 403

    requests = WithdrawRequest.query.order_by(
        WithdrawRequest.id.desc()
    ).all()

    return render_template(
        "admin_withdraw_requests.html",
        requests=requests
    )
    
@main.route('/admin/approve-withdraw/<int:req_id>')
@login_required
def approve_withdraw(req_id):

    if current_user.role != "admin":
        return "Unauthorized",403

    req = WithdrawRequest.query.get_or_404(req_id)

    if req.status != "pending":
        flash("Already processed")
        return redirect(url_for('main.admin_withdraw_requests'))

    req.status = "completed"

    db.session.commit()

    # 🔔 notify developer
    create_notification(
        user_id=req.user_id,
        title="Withdraw Approved ✅",
        message=f"Your withdraw ₹{req.amount} is approved",
        link=url_for('main.developer_dashboard')
    )

    flash("✅ Withdraw Approved")

    return redirect(url_for('main.admin_withdraw_requests'))

@main.route('/admin/reject-withdraw/<int:req_id>')
@login_required
def reject_withdraw(req_id):

    if current_user.role != "admin":
        return "Unauthorized",403

    req = WithdrawRequest.query.get_or_404(req_id)

    if req.status != "pending":
        flash("Already processed")
        return redirect(url_for('main.admin_withdraw_requests'))

    req.status = "rejected"

    db.session.commit()

    # 🔔 notify developer
    create_notification(
        user_id=req.user_id,
        title="Withdraw Rejected ❌",
        message="Your withdraw request was rejected",
        link=url_for('main.developer_dashboard')
    )

    flash("❌ Withdraw Rejected")

    return redirect(url_for('main.admin_withdraw_requests'))
@main.route('/admin/withdraw', methods=['GET','POST'])
@login_required
def admin_withdraw():

    if current_user.role != "admin":
        return "Unauthorized",403

    if request.method == "POST":

        amount = request.form["amount"]
        method = request.form["method"]
        details = request.form["details"]

        withdraw = AdminWithdraw(
            amount=amount,
            method=method,
            details=details
        )

        db.session.add(withdraw)
        db.session.commit()

        flash("Admin Withdraw Successful")

        return redirect(url_for('main.admin_dashboard'))

    return render_template("admin_withdraw.html")

@main.route('/admin/deactivate-user/<int:user_id>')
@login_required
def deactivate_user(user_id):

    if current_user.role != "admin":
        return "Unauthorized", 403

    user = User.query.get_or_404(user_id)

    user.is_active = False

    db.session.commit()

    flash("User deactivated successfully")

    return redirect(url_for('main.admin_dashboard'))

@main.route('/admin/activate-user/<int:user_id>')
@login_required
def activate_user(user_id):

    if current_user.role != "admin":
        return "Unauthorized", 403

    user = User.query.get_or_404(user_id)

    user.is_active = True

    db.session.commit()

    flash("User activated successfully")

    return redirect(url_for('main.admin_dashboard'))

@main.route("/search")
def search():

    query = request.args.get("q")

    if not query:
        return redirect(url_for("main.home"))

    # 🔎 SEARCH PROJECTS
    projects = Project.query.join(User).filter(
        Project.status == "open",
        User.is_active == True,
        or_(
            Project.title.ilike(f"%{query}%"),
            Project.description.ilike(f"%{query}%"),
            Project.category.ilike(f"%{query}%")
        )
    ).all()

    # 🔎 SEARCH DEVELOPERS
    developers = User.query.filter(
        User.role == "developer",
        User.is_active == True,
        or_(
            User.name.ilike(f"%{query}%"),
            User.skills.ilike(f"%{query}%")
        )
    ).all()

    return render_template(
        "search_results.html",
        projects=projects,
        developers=developers,
        query=query
    )
    
@main.route("/category/<category>")
def category_projects(category):

    # get projects of that category
    projects = Project.query.join(User).filter(
        Project.category.ilike(category),
        Project.status == "open",
        User.is_active == True
    ).order_by(Project.id.desc()).all()

    # अगर कोई project नहीं मिला
    if not projects:
        flash("No projects found in this category.")

    return render_template(
        "category_projects.html",
        projects=projects,
        category=category
    )
    
@main.route('/read-notification/<int:noti_id>')
@login_required
def read_notification(noti_id):

    n = Notification.query.get_or_404(noti_id)

    if n.user_id != current_user.id:
        return "Unauthorized", 403

    n.is_read = True
    db.session.commit()

    if n.link:
        return redirect(n.link)

    return redirect(url_for('main.home'))