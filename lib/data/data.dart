import '../models/categories_model.dart';

String apiKey = '563492ad6f9170000100000181ae42c6ac634e868db6b9ef46ecfae6';

List<CategoriesModel> getCategories(){

  List<CategoriesModel> categories = [];
  CategoriesModel categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1477199/pexels-photo-1477199.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'autumn';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1209843/pexels-photo-1209843.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'arts';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'nature';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/869258/pexels-photo-869258.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'winter';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/213399/pexels-photo-213399.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'animals';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1763075/pexels-photo-1763075.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'music';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/5866427/pexels-photo-5866427.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'cars';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1078958/pexels-photo-1078958.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'fashion';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/2983101/pexels-photo-2983101.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'food';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'travel';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://images.pexels.com/photos/1779487/pexels-photo-1779487.jpeg?auto=compress&cs=tinysrgb&h=350';
  categoryModel.category_name = 'technology';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();



  return categories;
}