from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'secretkey'
    
    from .auth import auth
    from .carteira import carteira
    from .home import home
    from .eventos import eventos

    app.register_blueprint(auth, url_prefix='/auth')
    app.register_blueprint(carteira, url_prefix='/carteira')
    app.register_blueprint(home, url_prefix='/')
    app.register_blueprint(eventos, url_prefix='/eventos')

    return app

