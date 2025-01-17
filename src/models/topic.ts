import mongoose from "mongoose";
import {v4 as uuidv4} from 'uuid';
const TopicOfInterestSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true,
  },
  name: {
    type: String,
    required: true,
  },
  recommendation: {
    type: Boolean,
    required: true,
  },
});

const Topic = mongoose.model("topic", TopicOfInterestSchema, 'Topics');

export default Topic;

