package svg.creator;

import vector.Vector;

public class SvgGraphShapeCreator extends SvgShapeCreator {
    int blockWidth;
    int blockHeight;
    public SvgGraphShapeCreator(int blockWidth, int blockHeight) {
        this.blockWidth = blockWidth;
        this.blockHeight = blockHeight;
    }

    public String createBeginEndBlock(int x, int y) {
        return createRect(x, y, blockWidth, blockHeight, blockWidth / 4, 0);
    }

    public String createExpressionBlock(int x, int y) {
        return createRect(x, y, blockWidth, blockHeight, 0, 0);
    }

    public String createIfBlock(int x, int y) {
        int halfWidth = blockWidth / 2;
        int halfHeight = blockHeight / 2;
        return createPolygon(x, y + halfHeight, x + halfWidth,
                y, x + blockWidth, y + halfHeight, x + halfWidth, y + blockHeight);
    }

    public String createCycleStartBlock(int x, int y) {
        int quarterHeight = blockHeight / 4;
        return createPolygon(x, y + quarterHeight, x + quarterHeight, y,
                x + blockWidth - quarterHeight, y, x + blockWidth, y + quarterHeight,
                x + blockWidth, y + blockHeight, x, y + blockHeight);
    }

    public String createCycleEndBlock(int x, int y) {
        int quarterHeight = blockHeight / 4;
        int threeForthHeight = 3 * quarterHeight;
        return createPolygon(x, y, x + blockWidth, y, x + blockWidth, y + threeForthHeight,
                x + blockWidth - quarterHeight, y + blockHeight, x + quarterHeight, y + blockHeight,
                x, y + threeForthHeight);
    }

    public String createArrowLine(int x1, int y1, int x2, int y2, int arrowLength) {
        int[] arrowCoordinates = calculateArrowLineCoordinates(x1, y1, x2, y2, arrowLength);
        return createPolyline(x1, y1, x2, y2, arrowCoordinates[0],
                arrowCoordinates[1], x2, y2, arrowCoordinates[2], arrowCoordinates[3]);
    }

    private int[] calculateArrowLineCoordinates(int x1, int y1, int x2, int y2, int arrowLength) {
        int[] coordinates = {0, 0, 0, 0};
        Vector endPointVector = new Vector(x2, y2);
        Vector lineVector = new Vector(x2, y2, x1, y1);
        Vector lineOrthogonalVector = lineVector.calculateOrthogonal();
        lineVector.multiply(0.5);
        lineOrthogonalVector.multiply(0.5);
        Vector arrowFirstVector = Vector.sum(lineVector, lineOrthogonalVector);
        lineOrthogonalVector.reverse();
        Vector arrowSecondVector = Vector.sum(lineVector, lineOrthogonalVector);
        arrowFirstVector.toUnit();
        arrowFirstVector.multiply(arrowLength);
        arrowSecondVector.toUnit();
        arrowSecondVector.multiply(arrowLength);
        arrowFirstVector.add(endPointVector);
        arrowSecondVector.add(endPointVector);
        coordinates[0] = (int) arrowFirstVector.getX();
        coordinates[1] = (int) arrowFirstVector.getY();
        coordinates[2] = (int) arrowSecondVector.getX();
        coordinates[3] = (int) arrowSecondVector.getY();
        return coordinates;
    }
}
