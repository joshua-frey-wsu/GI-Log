import { pool } from '../config/db.js';

class MemberRepository {
    
    // CREATE - Add a new Member
    async create(memberData) {
        try {
            const { email, passwordHash, firstName, lastName, birthDate } = memberData;
            const { rows } = await pool.query(
                'INSERT INTO members (email, password_hash, first_name, last_name, birth_date) \
                VALUES ($1, $2) \
                RETURNING user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt"',
                [email, passwordHash, firstName, lastName, birthDate]
            );
            return rows[0];
        } catch (error) {
            throw new Error(`Error creating member: ${error.message}`);
        }
    }

    // READ - Get all members with optional filtering
    async findAll(filters = {}, sort = {}) {
        try {
            const { rows } = await pool.query(
                'SELECT user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt" \
                FROM members'
            );
            console.log('members data: ', rows);
            return rows;
        } catch (error) {
            console.error('DB error: ', error);
            throw new Error(`Error fetching members: ${error.message}`);
        }
    }

    async findById(memberId) {
        try {
            const { rows } = await pool.query(
                'SELECT user_id AS "userId", email, first_name AS "firstName", last_name AS "lastName", birth_date AS "birthDate", created_at AS "createdAt" \
                FROM members \
                WHERE user_id = $1',
                [memberId]
            );
            console.log('member data: ', rows);
            return rows;
        } catch (error) {
            console.error('DB error: ', error);
            throw new Error(`Error fetching member (memberId = ${memberId}): ${error.message}`);
        }
    }

    async update(memberId, updateData) {

    }

    async delete(memberId) {

    }
}

export const memberRepository = new MemberRepository();