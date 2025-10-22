var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

builder.Services.AddControllersWithViews();

builder.AddNpgsqlDbContext<ApplicationDbContext>("identitydb");

// ============================================================================
// ⚠️ WARNING: Automatic Database Migrations - NOT RECOMMENDED FOR PRODUCTION ⚠️
// ============================================================================
// The AddMigration service automatically applies EF Core migrations at startup.
// 
// ISSUES FOR PRODUCTION:
// - No control over when migrations run
// - Can cause downtime during deployment
// - No easy rollback mechanism
// - Risk of data loss if migrations fail mid-execution
// - Not suitable for blue-green or canary deployments
// - Multiple instances might try to migrate simultaneously
//
// RECOMMENDED FOR PRODUCTION:
// - Generate SQL migration scripts: dotnet ef migrations script
// - Apply migrations manually or through deployment pipeline
// - Test migrations in staging environment first
// - Have rollback procedures ready
// - Use database migration tools (e.g., DbUp, Flyway, Liquibase)
//
// See PRODUCTION-READINESS.md for detailed guidance.
// ============================================================================
builder.Services.AddMigration<ApplicationDbContext, UsersSeed>();

builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
        .AddEntityFrameworkStores<ApplicationDbContext>()
        .AddDefaultTokenProviders();

// ============================================================================
// ⚠️ CRITICAL WARNING: NOT PRODUCTION READY ⚠️
// ============================================================================
// The following IdentityServer configuration is NOT suitable for production use.
// 
// ISSUES:
// 1. AddDeveloperSigningCredential() creates a temporary key file (tempkey.jwk)
//    - This key is NOT secure and should NEVER be used in production
//    - Keys will be lost on container/server restart
//    - Keys are not shared across multiple instances
//
// 2. KeyManagement.Enabled = false disables automatic key rotation
//    - This is a security risk for long-running production systems
//
// REQUIRED FOR PRODUCTION:
// - Use proper certificate-based signing credentials (.pfx certificate)
// - Store certificates in Azure Key Vault, AWS Secrets Manager, or similar
// - Enable KeyManagement or implement custom key storage
// - Configure proper certificate rotation policies
// - Test in staging with production-like configuration
//
// See PRODUCTION-READINESS.md for detailed requirements.
// ============================================================================

builder.Services.AddIdentityServer(options =>
{
    //options.IssuerUri = "null";
    options.Authentication.CookieLifetime = TimeSpan.FromHours(2);

    options.Events.RaiseErrorEvents = true;
    options.Events.RaiseInformationEvents = true;
    options.Events.RaiseFailureEvents = true;
    options.Events.RaiseSuccessEvents = true;

    // TODO: Remove this line in production.
    options.KeyManagement.Enabled = false;
})
.AddInMemoryIdentityResources(Config.GetResources())
.AddInMemoryApiScopes(Config.GetApiScopes())
.AddInMemoryApiResources(Config.GetApis())
.AddInMemoryClients(Config.GetClients(builder.Configuration))
.AddAspNetIdentity<ApplicationUser>()
// TODO: Not recommended for production - you need to store your key material somewhere secure
.AddDeveloperSigningCredential();

builder.Services.AddTransient<IProfileService, ProfileService>();
builder.Services.AddTransient<ILoginService<ApplicationUser>, EFLoginService>();
builder.Services.AddTransient<IRedirectService, RedirectService>();

var app = builder.Build();

app.MapDefaultEndpoints();

app.UseStaticFiles();

// This cookie policy fixes login issues with Chrome 80+ using HTTP
app.UseCookiePolicy(new CookiePolicyOptions { MinimumSameSitePolicy = SameSiteMode.Lax });
app.UseRouting();
app.UseIdentityServer();
app.UseAuthorization();

app.MapDefaultControllerRoute();

app.Run();
