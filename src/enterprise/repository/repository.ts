export interface IRepository<T> {
  save(type: T): Promise<T>;
  findBy(attributes: Partial<T>): Promise<T[]>;
  edit(type: T): Promise<T>;
  delete(id: number): Promise<boolean>;
  findAll(): Promise<T[]>;
}
