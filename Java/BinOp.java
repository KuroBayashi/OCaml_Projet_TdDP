import java.util.*;

class BinOp extends Instr {
  
  public enum Operator {ADD, SUB, DIV, MUL, EQ, NE, LT, LE, GT, GE};
  
  Operator op;
  PairV p;
  
  Value v;

  /* Constructors */
  public BinOp (PairV p, Operator op) {
    this.p = p;
    this.op = op;
  }
  
  private IntV exec_arith() {
    if (this.p.get_x() instanceof IntV && this.p.get_y() instanceof IntV) {
      IntV x = (IntV) this.p.get_x();
      IntV y = (IntV) this.p.get_y();
      
      IntV res = new IntV(0);
      
      switch (this.op) {
        case ADD:
          res.set_int(x.get_int() + y.get_int());
          break;
        case SUB:
          res.set_int(x.get_int() - y.get_int());
          break;
        case MUL:
          res.set_int(x.get_int() * y.get_int());
          break;
        case DIV:
          if (y.get_int() != 0)
            res.set_int(x.get_int() / y.get_int());
          break;
      }
      
      return res;
    }
    
    return null;
  }
  
  private BoolV exec_comp() {
    if (this.p.get_x() instanceof IntV)
      
      
      
    BoolV res = new BoolV(false);
      
    switch (this.op) {
      case EQ:
        res.set_bool(x == y);
        break;
      case NE:
        res.set_bool(x != y);
        break;
      case LT:
        res.set_bool(x < y);
        break;
      case LE:
        res.set_bool(x <= y);
        break;
      case GT:
        res.set_bool(x > y);
        break;
      case GE:
        res.set_bool(x >= y);
        break;
      
      return res;
  }
  
  void exec_instr(Config cf) {
    if (this.p.get_x() instanceof IntV) {
      IntV x = (IntV) this.p.get_x();
    }
    if (this.p.get_y() instanceof IntV) {
      IntV y = (IntV) this.p.get_y();
    }
  
    switch (this.op) {
      // Arithm
      case ADD:
      case SUB:
      case DIV:
      case MUL:
        this.v = exec_arith();
        break;
      // Comp
      case EQ:
      case NE:
      case LT:
      case LE:
      case GT:
      case GE:
        this.v = exec_comp();
        break;
    }
  
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
