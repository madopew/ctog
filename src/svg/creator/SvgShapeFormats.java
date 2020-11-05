package svg.creator;

class SvgShapeFormats {
    static final String RECT_FORMAT =
            "<rect x = \"%d\" y = \"%d\" width = \"%d\" height = \"%d\" rx = \"%d\" ry = \"%d\"/>";

    static final String LINE_FORMAT =
            "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\"/>";

    static final String POLYGON_FORMAT =
            "<polygon points = \"%s\"/>";

    static final String POLYLINE_FORMAT =
            "<polyline points=\"%s\"/>";
}
