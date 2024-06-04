import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

actor CeasarCipherAndDecipher{
  let letterText = "abcdefghijklmnopqrstuvwxyz";
  let letterChars = Text.toArray(letterText);

  public query func Decrypt(msg: Text, shift: Nat): async Text{
    let msgChars = Text.toVarArray(msg);
    var cipher = "";
    
    let iterRange = Iter.range(0, msg.size() - 1);
    for(i in iterRange){
      let isUppercase = Char.isUppercase(msgChars[i]);
      var index: ?Nat = null;
      
      if(isUppercase){
        let letter = Text.toArray(Text.toLowercase(Char.toText(msgChars[i])))[0];
        index := Array.indexOf<Char>(letter, letterChars, Char.equal);
      }else{
        index := Array.indexOf<Char>(msgChars[i], letterChars, Char.equal);
      };

      switch(index) {
        case (null) { 
          cipher := cipher # Text.fromChar(msgChars[i]);
        };
        
        // Encoutered a problem minusing the shift could result in a negative number
        case (?index) {
          var newindxInt: Int = index-shift;
          while( newindxInt < 0 ){
            newindxInt := newindxInt+26;
          };

          var newindxNat = Nat.fromText(Int.toText(newindxInt));
          
          switch(newindxNat) {
            case (null) { 
              cipher := cipher # Text.fromChar(msgChars[i]);
            };

            case (?newindxNat) { 
              if(isUppercase){
                cipher := cipher # Text.toUppercase(Text.fromChar(letterChars[newindxNat]));
              }else{
                cipher := cipher # Text.fromChar(letterChars[newindxNat]);
              }
            };
          };
        };
      };
    };

    return cipher;
  };

  public query func Encrypt(msg: Text, shift: Nat): async Text{
    let msgChars = Text.toVarArray(msg);
    var cipher = "";
    
    let iterRange = Iter.range(0, msg.size() - 1);
    for(i in iterRange){
      let isUppercase = Char.isUppercase(msgChars[i]);
      var index: ?Nat = null;
      
      if(isUppercase){
        let letter = Text.toArray(Text.toLowercase(Char.toText(msgChars[i])))[0];
        index := Array.indexOf<Char>(letter, letterChars, Char.equal);
      }else{
        index := Array.indexOf<Char>(msgChars[i], letterChars, Char.equal);
      };

      switch(index) {
        case (null) { 
          cipher := cipher # Text.fromChar(msgChars[i]);
        };
        case (?index) {
          if(isUppercase){
              cipher := cipher # Text.toUppercase(Text.fromChar(letterChars[(index+shift)%26]));
          }else{
            cipher := cipher # Text.fromChar(letterChars[(index+shift)%26]);
          }
        };
      };
    };

    return cipher;
  };
};