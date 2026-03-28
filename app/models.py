from app import db
from flask_login import UserMixin
from datetime import datetime


# ==========================
# USER MODEL
# ==========================

class User(UserMixin, db.Model):
    __tablename__ = "user"

    id = db.Column(db.Integer, primary_key=True)

    name = db.Column(db.String(100), nullable=False)

    email = db.Column(db.String(120), unique=True, nullable=False)

    password = db.Column(db.LargeBinary, nullable=False)

    role = db.Column(db.String(20), nullable=False)  # client, developer

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    skills = db.Column(db.String(300))
    bio = db.Column(db.Text)
    github = db.Column(db.String(200))
    resume = db.Column(db.String(200))

    # ⭐ ACTIVE STATUS (already added - correct position)
    is_active = db.Column(db.Boolean, default=True)

    # ================= RELATIONSHIPS =================

    projects = db.relationship(
        'Project',
        backref='client',
        lazy=True
    )

    bids = db.relationship(
        'Bid',
        backref='developer',
        lazy=True
    )



    # ⭐ ================= ADD THIS (AVG RATING) =================

    @property
    def avg_rating(self):
        reviews = Review.query.filter_by(developer_id=self.id).all()

        if not reviews:
            return 0

        return round(sum(r.rating for r in reviews) / len(reviews), 1)
# ==========================
# PROJECT MODEL
# ==========================

class Project(db.Model):
    __tablename__ = "project"

    id = db.Column(db.Integer, primary_key=True)

    title = db.Column(db.String(200), nullable=False)

    description = db.Column(db.Text, nullable=False)

    budget = db.Column(db.Integer, nullable=False)

    deadline = db.Column(db.Date, nullable=False)

    status = db.Column(db.String(20), default="open")

    category = db.Column(db.String(100))

    client_id = db.Column(
        db.Integer,
        db.ForeignKey('user.id'),
        nullable=False
    )

    bids = db.relationship('Bid', backref='project', lazy=True)

    reviews = db.relationship('Review', backref='project', lazy=True)
# ==========================
# BID MODEL
# ==========================

class Bid(db.Model):
    __tablename__ = "bid"

    id = db.Column(db.Integer, primary_key=True)
    bid_amount = db.Column(db.Integer, nullable=False)
    proposal = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), default="pending")

    project_id = db.Column(db.Integer, db.ForeignKey('project.id'), nullable=False)
    developer_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    
    # ==========================
# REVIEW / RATING MODEL
# ==========================

class Review(db.Model):
    __tablename__ = "review"

    id = db.Column(db.Integer, primary_key=True)
    rating = db.Column(db.Integer, nullable=False)  # 1 to 5
    comment = db.Column(db.Text)

    project_id = db.Column(db.Integer, db.ForeignKey('project.id'), nullable=False)
    client_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    developer_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    # ==========================
# PAYMENT MODEL
# ==========================


class Message(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    sender_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    receiver_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    project_id = db.Column(db.Integer, db.ForeignKey('project.id'), nullable=False)

    message = db.Column(db.Text, nullable=False)

    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    
class Portfolio(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    developer_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    title = db.Column(db.String(200))

    description = db.Column(db.Text)

    link = db.Column(db.String(300))
    
class ProjectFile(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    project_id = db.Column(db.Integer, db.ForeignKey('project.id'))

    filename = db.Column(db.String(200))
    
class Payment(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    project_id = db.Column(db.Integer, db.ForeignKey('project.id'))

    client_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    developer_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    amount = db.Column(db.Integer)

    platform_fee = db.Column(db.Integer)

    developer_amount = db.Column(db.Integer)

    method = db.Column(db.String(50))

    status = db.Column(db.String(20), default="completed")

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
     # ⭐ ADD THIS
     
    project = db.relationship("Project", backref="payments")
    
    project = db.relationship("Project")

    client = db.relationship("User", foreign_keys=[client_id])

    developer = db.relationship("User", foreign_keys=[developer_id])
class Deliverable(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    project_id = db.Column(
        db.Integer,
        db.ForeignKey('project.id')
    )

    developer_id = db.Column(
        db.Integer,
        db.ForeignKey('user.id')
    )

    file = db.Column(db.String(200))

    github_link = db.Column(db.String(300))

    live_link = db.Column(db.String(300))

    notes = db.Column(db.Text)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
class WithdrawRequest(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    amount = db.Column(db.Integer)

    method = db.Column(db.String(50))

    details = db.Column(db.String(200))

    status = db.Column(db.String(20), default="pending")

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship("User", backref="withdraw_requests")
    
class AdminWithdraw(db.Model):

    id = db.Column(db.Integer, primary_key=True)

    amount = db.Column(db.Integer)

    method = db.Column(db.String(50))

    details = db.Column(db.String(200))

    status = db.Column(db.String(20), default="completed")

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
class Notification(db.Model):
    __tablename__ = "notification"

    id = db.Column(db.Integer, primary_key=True)

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    title = db.Column(db.String(100))
    message = db.Column(db.String(255))

    link = db.Column(db.String(255))  # redirect link

    is_read = db.Column(db.Boolean, default=False)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)