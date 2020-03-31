class ProductValidator {

  String validateImages(List images){
    if(images.isEmpty) return "Adicione imagens do produto";
    return null;
  }
  String validateTitle(String text){
    if(text.isEmpty) return "Preencha o Titulo do Produto";
    return null;
  }

  String validateDescription(String text){
    if(text.isEmpty) return "Preencha a descrição do Produto";
    return null;
  }

  String validatePrice(String text) {
    double price = double.tryParse(text);
    if(price != null){
      if(!text.contains(".") || text.split(".")[1].length !=2)
        return "Utilize 2 casas decimais";
    } if(text.isEmpty){
      return "Preecha um valar con 2 casas decimais";
    }
    else{
      return null;
    }
    return null;
  }

  String validateStock(String text){
    if(text.isEmpty) return "Inserir Estoque";
    return null;
  }

  String validateUnidadeMedida(String text){
    if(text.isEmpty) return "O campo presciza conter algum dado exemplo: 2 Kg";
    return null;
  }
}