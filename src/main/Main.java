package main;

import svg.creator.SvgGraphShapeCreator;

public class Main {
    public static void main(String[] args) {
        SvgGraphShapeCreator c = new SvgGraphShapeCreator(200, 100);
        System.out.println(
                c.createArrowLine(0, 0, 175, 323, 15)
        );
    }
}
