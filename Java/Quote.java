import java.util.*;

class Quote extends Instr {
  Value v;

  /* Constructors */
  public Quote (Value v) {
    this.v = v;
  }

  void exec_instr(Config cf) {
    cf.set_value(this.v);
    cf.get_code().pop();
  }

  Value get_value() {
    return this.v;
  }

  void set_value(Value nv) {
    this.v = nv;
  }
}
