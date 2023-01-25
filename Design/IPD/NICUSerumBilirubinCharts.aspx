<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NICUSerumBilirubinCharts.aspx.cs" Inherits="Design_IPD_NICUSerumBilirubinCharts" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %> 
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>NICU - Serum Bilirubin Charts</title>
   
</head>
<body>
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory" style="text-align: center">
            <b> NICU - Serum Bilirubin Charts</b>
           <br /> <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Size="Large"></asp:Label> </div>
     <div class="POuter_Box_Inventory" >
          <div class="Purchaseheader">
             Baby Details
          </div>
        <div class="row">
            <div class="col-md-25">
	       <div class="row">
                <div class="col-md-3">
			           <label class="pull-left">Date of Birth</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                        <asp:TextBox ID="txtDOB" runat="server" ToolTip="Click To Select From Date"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtDOB_CalendarExtender" runat="server" TargetControlID="txtDOB"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
		           </div>
		            <div class="col-md-3">
			           <label class="pull-left">    Time of Birth </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                       

                      <asp:TextBox ID="txtTime" runat="server" MaxLength="5"  ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
		           </div> 
                <div class="col-md-3">
			           <label class="pull-left"> Gestation </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                        <asp:DropDownList ID="ddlgestationType" runat="server">
                                
                                <asp:ListItem Value="30">30 Weeks</asp:ListItem>
                                <asp:ListItem Value="35">35 Weeks</asp:ListItem>
                                <asp:ListItem Value="38">>=38 Weeks</asp:ListItem>
                            </asp:DropDownList>
		           </div>
	       </div>
                   <div class="row">
                        <div class="col-md-3">
			           <label class="pull-left">Direct Antiglobulin Test</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                         <asp:TextBox ID="txtDirectTest" runat="server"></asp:TextBox>
                   </div>
                        <div class="col-md-3">
			           <label class="pull-left">Baby Blood Group</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                     <asp:TextBox ID="txtBabyBG" runat="server"></asp:TextBox>
                   </div>
                         <div class="col-md-3">
			           <label class="pull-left" title="Smokes(PerDay)">Mother Blood Group</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <asp:TextBox ID="txtMotherBG" runat="server"></asp:TextBox>
                   </div>
                   </div>
                <div class="row">    
                     <asp:Label ID="lblUpdatedBy" runat="server" class="pull-right" ></asp:Label>            
			  			        
		           </div>
            </div></div></div>
              <div class="POuter_Box_Inventory" style="text-align: center">
          <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" ClientIDMode="Static" ToolTip="Click To Save" OnClick="btnSave_Click" />            
        </div> 
               <div class="POuter_Box_Inventory" >
          <div class="Purchaseheader">
           Bilirubin Thresholds Graph
          </div>
        <div class="row">
            <div class="col-md-25">
	    
                   <div class="row">
                      <div class="Purchaseheader"></div>
                <asp:Chart ID="chartGestation" runat="server" Width="950px" Height="350px" BackColor="WhiteSmoke">
                    <Legends>
                        <asp:Legend Name="DefaultLegend" Docking="Top" />
                    </Legends>
                    <Series>
                        <asp:Series ChartType="Line" Color="DarkGreen" BorderWidth="2" Name="Exchange Transfusion">
                        </asp:Series>
                        <asp:Series ChartType="Line" BorderWidth="2" Color="Blue" Name="Phototherapy">
                        </asp:Series>
                        <asp:Series ChartType="FastPoint" Color="Red" BorderWidth="2" Name="Total Serum Bilirubin">
                        </asp:Series>
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="ChartArea1">
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
                
            </div></div></div></div>
    </div>
    </form>
</body>
</html>
