import { pool } from '../config/db.js';

class MemberRepository {
    
    // CREATE - Add a new Member
    async create(memberData) {
        const { email, passwordHash, firstName, lastName, birthDate } = memberData;
        const { rows } = await pool.query(
            'INSERT INTO members (email, password_hash, first_name, last_name, birth_date) \
            VALUES ($1, $2) \
            RETURNING user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt"',
            [email, passwordHash, firstName, lastName, birthDate]
        );
        return rows[0];
    }

    // READ - Get all members with optional filtering
    async findAll(filters = {}, sort = {}) {
        const { rows } = await pool.query(
            'SELECT user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt" \
            FROM members'
        );
        console.log('members data: ', rows);
        return rows;
    }

    async findById(memberId) {
        const { rows } = await pool.query(
            'SELECT user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt" \
            FROM members \
            WHERE user_id = $1',
            [memberId]
        );
        console.log('member data: ', rows);
        return rows;
    }

    async update(memberId, updateData) {

    }

    async delete(memberId) {

    }
}

export const memberRepository = new MemberRepository();