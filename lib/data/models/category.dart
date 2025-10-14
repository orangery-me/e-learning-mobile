enum Category {
  programming('Programming'),
  design('Design'),
  projectManagement('Project Management'),
  dataScience('Data Science'),
  languageLearning('Language Learning'),
  development('Development'),
  webDevelopment('Web Development'),
  mobileDevelopment('Mobile Development'),
  aiAndMachineLearning('AI And Machine Learning'),
  cybersecurity('Cybersecurity'),
  cloudComputing('Cloud Computing'),
  devops('DevOps'),
  gameDevelopment('Game Development'),
  softwareEngineering('Software Engineering'),
  databases('Databases'),
  ;

  final String displayName;

  const Category(this.displayName);

  String mapNameToDbValue() {
    return displayName.replaceAll(' ', '_').toUpperCase();
  }

  static Category? fromDbValue(String dbValue) {
    for (var category in Category.values) {
      if (category.mapNameToDbValue() == dbValue) {
        return category;
      }
    }
    return null; // or throw an exception if preferred
  }
}
