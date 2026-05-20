import { memberController } from '../controllers/member.controller.js';
import { asyncHandler } from '../middlewares/asyncHandler.js';
import express from 'express';

const router = express.Router();

router.get('/', asyncHandler(memberController.getAll));

export default router;