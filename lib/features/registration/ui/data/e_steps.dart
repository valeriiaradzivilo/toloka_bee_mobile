enum ESteps {
  checkGeneralInfo,
  addRegistartInfo,
  addExtraInfo;

  ESteps? get nextStep => switch (this) {
        checkGeneralInfo => addRegistartInfo,
        addRegistartInfo => addExtraInfo,
        addExtraInfo => null,
      };

  ESteps? get previousStep => switch (this) {
        checkGeneralInfo => null,
        addRegistartInfo => checkGeneralInfo,
        addExtraInfo => addRegistartInfo,
      };
}
