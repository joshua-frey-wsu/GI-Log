import { memberService } from "../services/member.service.js";

class MemberController {

    // READ all members
    async getAll(req, res) {
        try {
            const members = await memberService.getAllMembers();
            if (members) {
                res.status(201).json({
                    success: true,
                    count: members.length,
                    data: members
                });
            }
        } catch (error) {
            console.error('Controller error: ', error);
            res.status(500).json({
                success: false,
                message: error.message
            });
        }
    }
}

export const memberController = new MemberController();