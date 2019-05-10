import java.util.*;

class Config extends Object {
  Value v;
  LinkedList<Instr> c;
  LinkedList<StackElem> s;

  /* Constructors */
  public Config (Value vl, LinkedList<Instr> cd, LinkedList<StackElem> se) {
    v = vl;
    c = cd;
    s = se;
  }

  // one-step execution 
  boolean exec_step() {
    if (c.isEmpty()) 
      return false;
    
    c.get(0).exec_instr(this);

    return true;
  }

  // run to completion
  void exec() {
    while (exec_step()) {}
  }

  // run for n steps
  void step(int n) {
    while (n > 0 && exec_step()) { n--; }
    // to be implemented
  }

  // Getters / Setters
  Value get_value() {
    return v;
  }
  LinkedList<Instr> get_code() {
    return c;
  }
  LinkedList<StackElem> get_stack() {
    return s;
  }

  void set_value(Value nv) {
    v = nv;
  }
  void set_code(LinkedList<Instr> nc) {
    c = nc;
  }
  void get_stack(LinkedList<StackElem> ns) {
    s = ns;
  }
}

