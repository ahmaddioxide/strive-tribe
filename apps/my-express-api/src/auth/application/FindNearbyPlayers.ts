// src/user/application/FindNearbyPlayers.ts
import { injectable, inject } from "inversify";
import UserModel from "../infrastructure/models/User";
import { Config } from "../../config/config";

@injectable()
export class FindNearbyPlayers {
  constructor(
    @inject(Config) private config: Config
  ) {}

  private calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
    const R = 6371; // Earth radius in km
    const φ1 = lat1 * Math.PI/180;
    const φ2 = lat2 * Math.PI/180;
    const Δφ = (lat2 - lat1) * Math.PI/180;
    const Δλ = (lon2 - lon1) * Math.PI/180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  }

  private parseCoord(coord: string): number {
    return parseFloat(coord) || 0;
  }

  async execute(userId: string, activitiesFilter: string[] = []) {
    try {
      // Get main user data
      const mainUser = await UserModel.findOne({ userId })
        .select('userId name profileImage placeName countryName state latitude longitude')
        .lean();

      if (!mainUser) throw new Error("User not found");
      if (!mainUser.latitude || !mainUser.longitude) {
        throw new Error("User location not available");
      }

      // Parse coordinates
      const mainLat = this.parseCoord(mainUser.latitude);
      const mainLon = this.parseCoord(mainUser.longitude);

      // Format main user response
      const mainUserData = {
        userId: mainUser.userId,
        name: mainUser.name,
        profileImage: mainUser.profileImage || '',
        location: {
          placeName: mainUser.placeName || '',
          countryName: mainUser.countryName || '',
          state: mainUser.state || ''
        }
      };

      // Find nearby players within 5km
      const allUsers = await UserModel.find({
        userId: { $ne: userId },
        latitude: { $exists: true, $ne: null },
        longitude: { $exists: true, $ne: null }
      }).select('userId name profileImage placeName countryName state latitude longitude')
        .lean();

      // Initial distance filter
      const nearbyPlayers = allUsers.filter(user => {
        try {
          const userLat = this.parseCoord(user.latitude!);
          const userLon = this.parseCoord(user.longitude!);
          return this.calculateDistance(mainLat, mainLon, userLat, userLon) <= 5;
        } catch {
          return false;
        }
      });

      // Get activities for nearby players
      const usersWithActivities = await UserModel.find({
        userId: { $in: nearbyPlayers.map(p => p.userId) }
      }).select('userId activities');

      // Create activity map with original casing
      const activityMap = new Map<string, string[]>();
      usersWithActivities.forEach(user => {
        activityMap.set(
          user.userId,
          user.activities.map(a => a.name)
        );
      });
      // Apply exact match filter
      const filteredPlayers = activitiesFilter.length > 0
        ? nearbyPlayers.filter(player => {
            const userActivities = activityMap.get(player.userId) || [];
            return activitiesFilter.some(filter => 
              userActivities.includes(filter)
            );
          })
        : nearbyPlayers;

      // Format final response
      const formattedPlayers = filteredPlayers.map(user => ({
        userId: user.userId,
        name: user.name,
        profileImage: user.profileImage || '',
        gamesPlayed: user.scheduledActivities?.length || 0,
        activities: activityMap.get(user.userId) || []
      }));

      return {
        success: true,
        mainUser: mainUserData,
        nearbyPlayers: {
          count: formattedPlayers.length,
          players: formattedPlayers
        }
      };

    } catch (error: any) {
      console.error("FindNearbyPlayers error:", error);
      throw new Error(error.message || "Failed to find nearby players");
    }
  }
}