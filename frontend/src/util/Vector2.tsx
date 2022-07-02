export default class Vector2 {
  readonly x: number;
  readonly y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  get length(): number {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }

  add(other: Vector2): Vector2 {
    return new Vector2(this.x + other.x, this.y + other.y);
  }

  subtract(other: Vector2): Vector2 {
    return this.add(other.multiply(-1));
  }

  multiply(scalar: number): Vector2 {
    return new Vector2(this.x * scalar, this.y * scalar);
  }

  distance(other: Vector2): number {
    return this.subtract(other).length;
  }

  normalize(): Vector2 {
    return this.multiply(1 / this.length);
  }

  static G = new Vector2(0, 1);

  static fromVectors(v1: Vector2, v2: Vector2): Vector2 {
    return v2.subtract(v1);
  }

  static random(min: number, max: number): Vector2 {
    return new Vector2(Math.random() * (max - min) + min, Math.random() * (max - min) + min);
  }
}