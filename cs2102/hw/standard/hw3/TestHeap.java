import java.util.Random;


class TestHeap extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap(int data, IHeap left, IHeap right) {
		super(data, left, right);
		this.left = left;
		this.right = right;
	}

	@Override
	public IHeap addElt(int e) {
		return new TestHeap (e, this.left, this.right);
	}
}




class TestHeap2 extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap2 (int data, IHeap left, IHeap right) {
		super (data, left, right);
		this.left = left;
		this.right = right;
	}

	@Override
	public IHeap remMinElt() {
		if (this.left.height() == 0 || this.right.height() == 0) {
			return super.remMinElt();
		} else {
			return new TestHeap2 (data, this.left, this.right.remMinElt());
		}
	}
}



class TestHeap3 extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap3(int data, IHeap left, IHeap right) {
		super (data, left, right);
		this.left = left;
		this.right = right;
	}

	@Override
	public boolean isBigger(int e) {
		return (this.data < e);
	}
}




class TestHeap4 extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap4(int data, IHeap left, IHeap right) {
		super (data, left, right);
		this.left = left;
		this.right = right;
	}
	
	@Override
	public IHeap addElt(int e) {
		return this.merge(new DataHeap(e, new DataHeap(e, new MtHeap(), new MtHeap()), new MtHeap()));
	}
}



class TestHeap5 extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap5(int data, IHeap left, IHeap right) {
		super (data, left, right);
		this.left = left;
		this.right = right;
	}
	
	@Override
	public IHeap remMinElt() {
		return new TestHeap5 (0, this.right, this.left);
	}
}



class TestHeap6 extends DataHeap {
	IHeap left;
	IHeap right;

	TestHeap6(int data, IHeap left, IHeap right) {
		super (data, left, right);
		this.left = left;
		this.right = right;
	}
	
	@Override
	public IHeap addElt(int e) {
		Random newElt = new Random();
		return new TestHeap5 (newElt.nextInt(), this.right, this.left);
	}
}