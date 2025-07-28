import { Controller, Get, Post, Param, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PaymentsService } from './payments.service';

@UseGuards(JwtAuthGuard)
@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post()
  create(@Body() body: any) {
    return this.paymentsService.create(body);
  }

  @Get()
  findAll() {
    return this.paymentsService.findAll();
  }

@Get('stats')
getStats() {
  return this.paymentsService.getStats();
}

@Get(':id')
findOne(@Param('id') id: string) {
  return this.paymentsService.findOne(id);
}

}
