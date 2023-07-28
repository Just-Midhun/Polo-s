import 'package:firebase_auth/firebase_auth.dart';

import 'model/user_model.dart';

String mapKey = "AIzaSyAIwBq6fp6TDzWMtHKfB9p2IlrT1ys27tM";
String encodedPoints =
    "ujpy@_w`rMRGD?HD|@SpB]j@Cx@BlDRl@Cp@Mj@WXGbDAnAKvDs@`BUhAAhAAvCFzBAhB?xAM~@Ob@Cb@@\\F^Rd@`@PVCHI`@IR]b@{@d@o@Xm@XQRQVhB~@rAbAvAbAfFfCl@TvA\\rARx@DnBCjCMdBGtBCzAJbC`@r@?VIbEOxO_@jGSrCEVFf@@`A@n@F~E`A`Cf@`@VTXr@hAn@pAV`@x@dAPN\\P`Ad@fEhClD~BXLf@JbD^tDd@dCNlCNhAL|AX~Bd@v@\\~BtApBnArAt@~@Zt@NnC\\fAXt@Xv@Xf@Lj@FxFCzAEh@I`@QZOf@e@jAeAd@Wn@Ud@Ml@Gp@AxABvBJpBDnAB`B?bEK|AKjGMvBFxKTjAFlAJxDp@zBXnH^lBNr@JzDbAdBj@t@X`@RHFl@T`ANrAFjABlELdCB`@CTKb@Yh@m@X_@d@eAl@qAf@_AZa@fAaAfAq@jAa@l@EfBk@nAm@j@w@Rg@Lc@Fs@Ak@Q}Ak@sDi@wDAs@@g@DQVk@x@aAj@i@z@gAfAeAT_@t@eBLi@RaBn@uDh@qCTq@\\m@~A_Bt@g@dAc@tAInBER@fF[vAElBAvBL`CTxB\\fB\\hCd@n@Jn@@hAEl@Ml@Y`@W^_@\\m@`@u@rAoDVk@l@}@n@q@ZUjAq@dAa@d@K^CrABjHb@lLx@vHv@rEh@HyEBqBBaG?cE?[Is@FgAFwG?i@BuBlAEpBGfA@hEGhDAl@ACm@IcAUeCAgA?e@E{@OmAGg@CYSgBg@iAW[g@]e@{@Ia@Eg@EWOk@i@cBKSqAwCC]BoAAg@C[QQO[Kc@G_@Kc@Ic@F_@D_@Ga@CYWqBk@cB[aAk@eCa@aAKQ[Y_CyBq@_@^q@uD_ICWpD}@r@xATCHM|A}D`@q@Vw@RKj@Dd@T";

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;
UserModel? userModelCurrentInfo;

// final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// User? firebaseUser;
// UserModel? userModelCurrentInfo;
