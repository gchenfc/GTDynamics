/******************************* Jumping Robot Wrapper Interface File *******************************/

namespace gtdynamics {

/****************************************** Factors ******************************************/

#include <gtdynamics/jumpingrobot/factors/PneumaticFactors.h>
#include <gtdynamics/jumpingrobot/factors/PneumaticActuatorFactors.h>
class GasLawFactor: gtsam::NonlinearFactor{
   GasLawFactor(gtsam::Key p_key, gtsam::Key v_key, gtsam::Key m_key,
                 const gtsam::noiseModel::Base *cost_model,
                 const double c);
};

class MassFlowRateFactor: gtsam::NonlinearFactor{
  MassFlowRateFactor(gtsam::Key pm_key, gtsam::Key ps_key, gtsam::Key mdot_key,
                 const gtsam::noiseModel::Base* cost_model,
                 const double D, const double L, const double mu, const double epsilon, const double k);
  
  double computeExpectedMassFlow(
      const double &pm, const double &ps, const double &mdot);
};

class ValveControlFactor: gtsam::NonlinearFactor{
  ValveControlFactor(gtsam::Key t_key, gtsam::Key to_key, gtsam::Key tc_key, 
                     gtsam::Key mdot_key, gtsam::Key true_mdot_key,
                     const gtsam::noiseModel::Base *cost_model,
                    const double ct);
  
  double computeExpectedTrueMassFlow(
      const double &t, const double &to, const double &tc, const double &mdot);
};

class ActuatorVolumeFactor: gtsam::NonlinearFactor{
  ActuatorVolumeFactor(gtsam::Key v_key, gtsam::Key l_key,
                 const gtsam::noiseModel::Base *cost_model,
                 const double D, const double L);
  
  double computeVolume(const double &l);
};

class ClippingActuatorFactor: gtsam::NonlinearFactor{
  ClippingActuatorFactor(gtsam::Key delta_x_key, gtsam::Key p_key,
                          gtsam::Key f_key,
                          const gtsam::noiseModel::Base *cost_model);
};

class SmoothActuatorFactor: gtsam::NonlinearFactor{
  SmoothActuatorFactor(gtsam::Key delta_x_key, gtsam::Key p_key,
                          gtsam::Key f_key,
                          const gtsam::noiseModel::Base *cost_model);
};

class ForceBalanceFactor: gtsam::NonlinearFactor{
  ForceBalanceFactor(gtsam::Key delta_x_key, gtsam::Key q_key, gtsam::Key f_key,
                     const gtsam::noiseModel::Base *cost_model,
                     const double k, const double r, const double q_rest,
                     const bool contract);
};

class JointTorqueFactor: gtsam::NonlinearFactor{
  JointTorqueFactor(gtsam::Key q_key, gtsam::Key v_key, gtsam::Key f_key,
                    gtsam::Key torque_key,
                    const gtsam::noiseModel::Base *cost_model,
                    const double q_limit, const double ka, const double r,
                    const double b, const bool positive);
};

#include <gtdynamics/jumpingrobot/factors/PosePointFactor.h>
class PosePointFactor: gtsam::NonlinearFactor{
  PosePointFactor(gtsam::Key pose_key, gtsam::Key point_key,
                   const gtsam::noiseModel::Base *cost_model,
                   const gtsam::Point3 point_local);
};

#include <gtdynamics/jumpingrobot/factors/ProjectionFactorPPC.h>
class CustomProjectionFactor: gtsam::NonlinearFactor{
  CustomProjectionFactor(const gtsam::Point2 measured,
                         const gtsam::noiseModel::Base *model,
                         gtsam::Key poseKey, gtsam::Key pointKey,
                         gtsam::Key calibKey);
};

void addPriorFactorCal3Bundler(gtsam::NonlinearFactorGraph& graph, gtsam::Key key,
                            const gtsam::Cal3Bundler& prior,
                            const gtsam::noiseModel::Base *model);

#include <gtdynamics/jumpingrobot/factors/SystemIdentificationFactors.h>
class ForceBalanceFactorId: gtsam::NonlinearFactor{
  ForceBalanceFactorId(gtsam::Key delta_x_key, gtsam::Key q_key, gtsam::Key f_key,
                       gtsam::Key k_key,
                     const gtsam::noiseModel::Base *cost_model,
                     const double r, const double q_rest,
                     const bool contract = false);
};

class JointTorqueFactorId: gtsam::NonlinearFactor{
  JointTorqueFactorId(gtsam::Key q_key, gtsam::Key v_key, gtsam::Key f_key,
                    gtsam::Key torque_key, gtsam::Key b_key,
                    const gtsam::noiseModel::Base *cost_model,
                    const double q_limit, const double ka, const double r,
                const bool positive = false);
};

class ActuatorVolumeFactorId: gtsam::NonlinearFactor{
  ActuatorVolumeFactorId(gtsam::Key v_key, gtsam::Key l_key, gtsam::Key d_tube_key,
                       const gtsam::noiseModel::Base *cost_model,
                       const double l_tube);
};

class MassFlowRateFactorId: gtsam::NonlinearFactor{
  MassFlowRateFactorId(gtsam::Key pm_key, gtsam::Key ps_key, gtsam::Key mdot_key,
                     gtsam::Key d_tube_key,
                     const gtsam::noiseModel::Base *cost_model,
                     const double D, const double L, const double mu,
                     const double epsilon, const double k);
};

#include <gtdynamics/jumpingrobot/factors/ValueUtils.h>
gtsam::Values ExtractValues(const gtsam::Values& values, const gtsam::KeyVector& keys);
gtsam::Values ExtractValues(const gtsam::Values& values, const gtsam::KeySet& keys);
gtsam::KeyVector KeySetToKeyVector(const gtsam::KeySet& keys);

gtsam::NonlinearFactorGraph RekeyNonlinearGraph(const gtsam::NonlinearFactorGraph& graph, 
                                                const gtsam::KeyVector& replaced_keys, 
                                                const gtsam::KeyVector& replacement_keys);
gtsam::Values RekeyValues(const gtsam::Values& values, const int offset, 
                          const gtsam::KeyVector& skip_keys);

#include <gtdynamics/jumpingrobot/factors/JRCollocationFactors.h>
void AddSourceMassCollocationFactor(
    gtsam::NonlinearFactorGraph @graph,
    const gtsam::KeyVector& mdot_prev_keys,
    const gtsam::KeyVector& mdot_curr_keys,
    gtsam::Key source_mass_key_prev, gtsam::Key source_mass_key_curr,
    gtsam::Key dt_key, bool isEuler,
    const gtsam::noiseModel::Base *cost_model);

void AddTimeCollocationFactor(
  gtsam::NonlinearFactorGraph @graph,
  gtsam::Key t_prev_key, gtsam::Key t_curr_key, gtsam::Key dt_key,
  const gtsam::noiseModel::Base *cost_model);

void AddJumpGuardFactor(
  gtsam::NonlinearFactorGraph @graph, gtsam::Key wrench_key,
  const gtsam::noiseModel::Base *cost_model);

#include <gtdynamics/jumpingrobot/factors/PneumaticActuator.h>

class PriorValues {
  double q;
  double v;
  double Ps;
  double m;
  double t;
  double to;
  double tc;
};

class PneumaticActuator {
  PneumaticActuator();

  gtsam::NonlinearFactorGraph actuatorFactorGraph(const int t) const;

  gtsam::NonlinearFactorGraph actuatorPriorGraph(const int t,  const gtdynamics::PriorValues& prior_values) const;

  gtsam::Values actuatorInitValues(const int t, const gtdynamics::PriorValues& prior_values) const;

  gtdynamics::PriorValues priorValues();

};

gtsam::Values optimize_LMQR(const gtsam::NonlinearFactorGraph& graph, const gtsam::Values& init_values);




#include <gtdynamics/jumpingrobot/factors/CollocationExample.h>
gtsam::Values getExampleGraphValues(gtsam::NonlinearFactorGraph& graph);



// need to borrow this from GTSAM since GTSAM doesn't have fixed-size vector versions
#include <gtdynamics/jumpingrobot/factors/BetweenFactor.h>
template<T = {double, gtsam::Vector2, gtsam::Vector3, gtsam::Vector4, gtsam::Vector5, gtsam::Vector6}>
class BetweenFactor : gtsam::NonlinearFactor {
  BetweenFactor(size_t key1, size_t key2, const T& measured, const gtsam::noiseModel::Base* model);
  // T prior() const;

  void print(const string &s,
             const gtsam::KeyFormatter &keyFormatter);
};

}  // namespace gtdynamics
