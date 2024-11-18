from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'secretkey'
    
    from .auth import auth
    from .carteira import carteira
    from .home import home

    app.register_blueprint(auth, url_prefix='/auth')
    app.register_blueprint(carteira, url_prefix='/carteira')
    app.register_blueprint(home, url_prefix='/')

    return app

