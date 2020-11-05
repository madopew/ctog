package svg.creator;

public class SvgShapeCreator {

    public String createRect(int x, int y, int width, int height, int rx, int ry) {
        if(width < 0 || height < 0 || rx < 0 || ry < 0)
            throw new IllegalArgumentException("rectangle parameters less than zero");
        return String.format(SvgShapeFormats.RECT_FORMAT, x, y, width, height, rx, ry);
    }

    public String createLine(int x1, int y1, int x2, int y2) {
        return String.format(SvgShapeFormats.LINE_FORMAT, x1, y1, x2, y2);
    }

    public String createPolygon(int... coordinates) {
        int length = coordinates.length;
        if(length < 6)
            throw new IllegalArgumentException("polygon has less than 3 points");
        if(length % 2 != 0)
            throw new IllegalArgumentException("coordinates amount not even");
        return String.format(SvgShapeFormats.POLYGON_FORMAT, coordinatesToPoints(coordinates));
    }

    public String createPolyline(int... coordinates) {
        int length = coordinates.length;
        if(length < 4)
            throw new IllegalArgumentException("polyline has less than 2 points");
        if(length % 2 != 0)
            throw new IllegalArgumentException("coordinates amount not even");
        return String.format(SvgShapeFormats.POLYLINE_FORMAT, coordinatesToPoints(coordinates));
    }

    String coordinatesToPoints(int... coordinates) {
        int length = coordinates.length;
        StringBuilder points = new StringBuilder();
        for(int i = 0; i < length - 2; i += 2) {
            points.append(coordinates[i])
                    .append(' ')
                    .append(coordinates[i+1])
                    .append(", ");
        }
        points.append(coordinates[length - 2])
                .append(' ')
                .append(coordinates[length -1]);
        return points.toString();
    }
}
