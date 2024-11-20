from flask import Blueprint, render_template, url_for, session

carteira = Blueprint('carteira', __name__)

@carteira.route('/')
def paginacarteira():
    return render_template('carteira.html', saldo=session.get('saldo'))

@carteira.route('/compra')
def compra():
    return render_template('compra.html')
