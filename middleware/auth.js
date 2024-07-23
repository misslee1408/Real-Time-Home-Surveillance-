const ensureAuthenticated = (req, res, next) => {
  if (req.session.user) {
    return next();
  } else {
    return res.status(401).json({ message: 'Unauthorized' });
  }
};

module.exports = ensureAuthenticated;  // Export the middleware
