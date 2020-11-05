package vector;

public class Vector {
    double x;
    double y;
    double magnitude;

    public Vector(double x, double y) {
        this.x = x;
        this.y = y;
        calculateMagnitude();
    }

    public Vector(double x1, double y1, double x2, double y2) {
        this(x2 - x1, y2 - y1);
    }

    public Vector(Vector v) {
        this.x = v.x;
        this.y = v.y;
        this.magnitude = v.magnitude;
    }

    void calculateMagnitude() {
        magnitude = Math.sqrt(x*x + y*y);
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    public double getMagnitude() {
        return magnitude;
    }

    public void add(Vector v) {
        x += v.x;
        y += v.y;
        calculateMagnitude();
    }

    public static Vector sum(Vector... vectors) {
        Vector v = new Vector(vectors[0]);
        for(int i = 1; i < vectors.length; i++)
            v.add(vectors[i]);
        return v;
    }

    public void multiply(double magnitude) {
        x *= magnitude;
        y *= magnitude;
        calculateMagnitude();
    }

    public void reverse() {
        multiply(-1);
    }

    public void toUnit() {
        if(magnitude != 1)
            multiply(1 / magnitude);
    }

    public Vector calculateOrthogonal() {
        return new Vector(y, -x);
    }

    @Override
    public String toString() {
        return String.format("(%.1f; %.1f)", x, y);
    }
}
