from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager, current_user
from config import Config

db = SQLAlchemy()
migrate = Migrate()
login_manager = LoginManager()


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # ================= INIT EXTENSIONS =================
    db.init_app(app)
    migrate.init_app(app, db)
    login_manager.init_app(app)
    login_manager.login_view = "main.login"

    # ================= IMPORT MODELS =================
    from app import models

    # ================= BLUEPRINT =================
    from app.routes import main
    app.register_blueprint(main)

    # ================= NOTIFICATION CONTEXT =================
    from app.models import Notification

    @app.context_processor
    def inject_notifications():

        if current_user.is_authenticated:
            notifications = Notification.query.filter_by(
                user_id=current_user.id,
                is_read=False
            ).order_by(Notification.id.desc()).limit(5).all()
        else:
            notifications = []

        return dict(notifications=notifications)

    return app


# ================= LOGIN LOADER =================
from app.models import User

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))