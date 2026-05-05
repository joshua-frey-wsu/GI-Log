import { memberController } from '../controllers/member.controller.js';
import express from 'express';

const router = express.Router();

router.get('/', memberController.getAll);

export default router;