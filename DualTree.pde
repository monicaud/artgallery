class Node{
  Node left, right;
  Triangle t;
  
  public Node(Triangle _t){
    t = _t;
  }
  public int size(){
    int size=0;
    if(left == null && right == null)
      return 1;
    if(right != null)
      size = 1 + right.size();
    if(left != null)
      size = 1 + left.size();
    return size;
  }
  public boolean insert(Triangle _t){
    if(left != null){ //<>//
      if(left.insert(_t)){
        return true;
      }
    }
    
    else if(right != null){ //<>//
      if(right.insert(_t)){
        return true;
      }
    }
    
    if(left == null){ //<>//
      if(t.adjacentTo(_t)){
        left = new Node(_t);
        return true;
      }
    }
    else if(right == null){ //<>//
      if(t.adjacentTo(_t)){
        right = new Node(_t);
        return true;
      }
    }
    //println("here");
    return false;
  }
  
  public void setColors(){
    t.setColors();
    if(left != null){
      left.setColors();
      }
      
      if(right != null){
        right.setColors();
      }
  }
}
