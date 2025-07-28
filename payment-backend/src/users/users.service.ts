import { Injectable, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from './user.schema';
import { Model } from 'mongoose';

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}

  async findByUsername(username: string): Promise<any> {
    return this.userModel.findOne({ username }).lean().exec();
  }

  async createUser(username: string, password: string, role: 'admin' | 'viewer') {
    try {
      return await this.userModel.create({ username, password, role });
    } catch (error) {
      if (error.code === 11000) {
        throw new ConflictException('Username already exists');
      }
      throw error;
    }
  }

  async findAll() {
    return this.userModel.find();
  }
}
