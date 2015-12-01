from PIL import Image
path='/all-caches/veja-ponto-com/bundle/gems/rails-4.1.6/guides/assets/images/oscardelben.jpg'
path='/home/romeu/Abril/ALDA/aapg-services/src/test/resources/playboy-logo.jpg'
path='walterwhitereal.jpg'
src = Image.open(path)
pictureData = src.resize((640, 640)).tobytes("jpeg", "RGB")
picturePreview = src.resize((96, 96)).tobytes("jpeg", "RGB")
