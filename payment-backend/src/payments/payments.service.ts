import { Injectable } from '@nestjs/common';
import { v4 as uuid } from 'uuid';

@Injectable()
export class PaymentsService {
  private payments: Array<{
    id: string;
    amount: number;
    status: string;
    createdAt: Date;
    [key: string]: any;
  }> = [];

  create(paymentDto: any) {
    const newPayment = {
      id: uuid(),
      ...paymentDto,
      createdAt: new Date(),
    };
    this.payments.push(newPayment);
    return newPayment;
  }

  findAll() {
    return this.payments;
  }

  findOne(id: string) {
    return this.payments.find((payment) => payment.id === id);
  }

  getStats() {
    const total = this.payments.length;
    const failed = this.payments.filter(p => p.status === 'failed').length;
    const revenue = this.payments
      .filter(p => p.status === 'success')
      .reduce((sum, p) => sum + Number(p.amount), 0);

    return {
      totalTransactions: total,
      failedTransactions: failed,
      totalRevenue: revenue,
    };
  }
}
