from flask import Blueprint, render_template, url_for

carteira = Blueprint('carteira', __name__)

@carteira.route('/')
def paginacarteira():
    return render_template('carteira.html')

@carteira.route('/compra')
def compra():
    return render_template('compra.html')
