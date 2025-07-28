import { Controller, Get, Post, Body } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  async addUser(@Body() body: { username: string; password: string; role: 'admin' | 'viewer' }) {
    return this.usersService.createUser(body.username, body.password, body.role);
  }

  @Get()
  async listUsers() {
    return this.usersService.findAll();
  }
}
