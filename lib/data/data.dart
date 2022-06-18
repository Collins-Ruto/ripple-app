import '../models/categories_model.dart';

String apiKey = '563492ad6f9170000100000181ae42c6ac634e868db6b9ef46ecfae6';

List<CategoriesModel> getCategories(){

  List<CategoriesModel> categories = [];
  CategoriesModel categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://imgs.search.brave.com/ldF504FFYClBkmiAIhVIaCG2olmMdBun_n83OzZRLHQ/rs:fit:1200:800:1/g:ce/aHR0cHM6Ly9zdGF0/aWMubWlyYWhlemUu/b3JnL3dpbmRvd3N3/YWxscGFwZXJ3aWtp/L3RodW1iLzgvOGEv/VHdpbGlnaHRfYXRf/TGFrZV9Qb3dlbGwl/MkNfQXJpem9uYS5q/cGcvMTI4MHB4LVR3/aWxpZ2h0X2F0X0xh/a2VfUG93ZWxsJTJD/X0FyaXpvbmEuanBn';
  categoryModel.category_name = 'autumn';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://imgs.search.brave.com/ynaakLzJudsXlYN_yw9brtEogoLI2mGtnG5DN3YAEGI/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC56/aHhMcmpNMmRGc0pS/WEhIT0Z5RUVBSGFF/SyZwaWQ9QXBp';
  categoryModel.category_name = 'cars';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://imgs.search.brave.com/C2imspUtb_msuX8Rhzy8k8Qv0JO5wbGpZIr_boBBrII/rs:fit:844:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5x/Y05OSHZZWUN6MDJE/RVduZG13ZDRBSGFF/SyZwaWQ9QXBp';
  categoryModel.category_name = 'nature';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://imgs.search.brave.com/7s2_00ROlMl_ArxFOvwR2_KXIdrbogDSjYBra_ENjzw/rs:fit:759:225:1/g:ce/aHR0cHM6Ly90c2Uy/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5L/bkFWd1k5cDUzM3Jw/WG1ybnBGeXN3SGFF/byZwaWQ9QXBp';
  categoryModel.category_name = 'snow';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  categoryModel.img_url = 'https://wallup.net/wp-content/uploads/2016/01/169826-deer-animals-nature-landscape-sunlight-mammals.jpg';
  categoryModel.category_name = 'animals';
  categories.add(categoryModel);
  categoryModel = CategoriesModel();

  return categories;
}