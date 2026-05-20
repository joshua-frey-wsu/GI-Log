import { memberService } from "../services/member.service.js";
import { NotFoundError } from "../helpers/ApiError.js";
class MemberController {

    // READ all members
    async getAll(req, res) {
        const members = await memberService.getAllMembers();
        if (!members) {
            // Throws NotFoundError which gets caught by asyncHandler
            throw new NotFoundError('Members');
        }
        res.status(201).json({
            success: true,
            count: members.length,
            data: members
        });
    }
}

export const memberController = new MemberController();