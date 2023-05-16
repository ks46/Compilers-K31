class BooleanArrays {
	public static void main(String[] a) {
	    boolean[] x;
        boolean y;
        int len;
	    x = new boolean[2];

        x[0] = true;
        x[1] = false;

        if ((x[0]) && (x[1])) {
            System.out.println(1);
        } else {
            System.out.println(0);
        }

        len = x.length;
        System.out.println(len);

        y = x[1];

        if (y) {
            System.out.println(1);
        } else {
            System.out.println(0);
        }
	}
}
