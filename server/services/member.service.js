import { memberRepository } from "../repositories/member.repository.js";

class MemberService {
    async createMember(memberData) {

    }

    async getAllMembers() {
        return await memberRepository.findAll();
    }
}

export const memberService = new MemberService();