import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService
  ) {}

  async validateUser(username: string, password: string): Promise<any> {
    const user = await this.usersService.findByUsername(username);

    if (!user) {
      throw new UnauthorizedException('Invalid username');
    }

    // Very important: convert doc to plain object if needed
    const userObj = typeof user.toObject === 'function' ? user.toObject() : user;

    if (userObj.password !== password) {
      throw new UnauthorizedException('Invalid password');
    }

    const { password: _, ...result } = userObj;
    return result;
  }

  async login(user: any) {
    const payload = { username: user.username, role: user.role };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
