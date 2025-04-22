enum ESteps {
  checkGeneralInfo,
  addRegisterInfo,
  addExtraInfo,
  addContactInfo;

  ESteps? get nextStep => switch (this) {
        checkGeneralInfo => addRegisterInfo,
        addRegisterInfo => addExtraInfo,
        addExtraInfo => addContactInfo,
        addContactInfo => null,
      };

  ESteps? get previousStep => switch (this) {
        checkGeneralInfo => null,
        addRegisterInfo => checkGeneralInfo,
        addExtraInfo => addRegisterInfo,
        addContactInfo => addExtraInfo,
      };
}
