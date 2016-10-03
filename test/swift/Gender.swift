
// Mostly stolen from http://abcnewsgocom/blogs/headlines/2014/02/heres-a-list-of-58-gender-options-for-facebook-users/
enum Gender: Int {
  case Undefined = 0,
      Female,
      Male,
      Other,
      Agender,
      Androgyne,
      Androgynous,
      Bigender,
      Cisgender,
      CisgenderFemale,
      CisgenderMale,
      FemaleToMale,
      GenderFluid,
      GenderNonconforming,
      GenderQuestioning,
      GenderVariant,
      Genderqueer,
      Intersex,
      MaleToFemale,
      Neither,
      Neutrois,
      Nonbinary,
      Pangender,
      Trans,
      TransStar,
      TransFemale,
      TransStarFemale,
      TransMale,
      TransStarMale,
      TransPerson,
      TransStarPerson,
      Transfeminine,
      Transgender,
      TransgenderFemale,
      TransgenderMale,
      TransgenderPerson,
      Transmasculine,
      Transsexual,
      TranssexualFemale,
      TranssexualMale,
      TranssexualPerson

      func toString() -> String {
        return String(describing: self)
      }
}

func ==(lhs: Gender, rhs: Gender) -> Bool {
  return lhs.rawValue == rhs.rawValue
}
