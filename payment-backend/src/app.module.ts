import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { PaymentsModule } from './payments/payments.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb+srv://vardhman:vardhman525@yolo.uyyuzjt.mongodb.net/payment-dashboard?retryWrites=true&w=majority'),
    AuthModule,
    PaymentsModule,
    UsersModule,
  ],
})
export class AppModule {}
