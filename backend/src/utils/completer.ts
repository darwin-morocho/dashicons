/* eslint-disable @typescript-eslint/no-empty-function */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable no-unused-vars */
export interface PromiseCompleter<R> {
  promise: Promise<R>;
  resolve: (value?: R | PromiseLike<R>) => void;
  reject: (error?: any, stackTrace?: string) => void;
}

export class PromiseWrapper {
  static resolve<T>(obj: T): Promise<T> {
    return Promise.resolve(obj);
  }

  static reject(obj: any, _: any): Promise<any> {
    return Promise.reject(obj);
  }

  // Note: We can't rename this method into `catch`, as this is not a valid
  // method name in Dart.
  static catchError<T>(
    promise: Promise<T>,
    onError: (error: any) => T | PromiseLike<T>
  ): Promise<T> {
    return promise.catch(onError);
  }

  static all(promises: any[]): Promise<any> {
    if (promises.length === 0) return Promise.resolve([]);
    return Promise.all(promises);
  }

  static then<T, U>(
    promise: Promise<T>,
    success: (value: T) => U | PromiseLike<U>,
    rejection?: (error: any, stack?: any) => U | PromiseLike<U>
  ): Promise<U> {
    return promise.then(success, rejection);
  }

  static wrap<T>(computation: () => T): Promise<T> {
    return new Promise((res, rej) => {
      try {
        res(computation());
      } catch (e) {
        rej(e);
      }
    });
  }

  static scheduleMicrotask(computation: () => any): void {
    PromiseWrapper.then(PromiseWrapper.resolve(null), computation, (_) => {});
  }

  static isPromise(obj: any): boolean {
    return obj instanceof Promise;
  }

  static completer(): PromiseCompleter<any> {
    let resolve: any;
    let reject: any;

    const p = new Promise((res, rej) => {
      resolve = res;
      reject = rej;
    });

    return { promise: p, resolve, reject };
  }
}
