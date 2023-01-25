<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DrugReaction_Report.aspx.cs" Inherits="Design_Store_DrugReaction_Report" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>




<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager ID="sc1" runat="server"></asp:ScriptManager>
    
   
        

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Drug Reaction Report</b><br />
            </div>
              <div class="content">
                            



                        </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        UHID
                        </div>
                    <div class="col-md-4"> 
                        <asp:TextBox ID="txtUHID" runat="server"   ClientIDMode="Static"   ToolTip="UHID" ></asp:TextBox>
							
                           </div>
                	<div class="col-md-3">
							<label class="pull-left">From Date  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-4">
								<asp:TextBox ID="txtSearchFromDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">To Date </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-4">
							  <asp:TextBox ID="txtSearchToDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select To Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
                    </div>
                </div>
                
                          <div class="POuter_Box_Inventory" style="text-align: center;">
                      <div class="row">
                    <div class="col-md-6">
                       
                        </div>
                    <div style="text-align:center" class="col-md-6">
							<asp:Button ID="btnSearch1" runat="server" CssClass="ItDoseButton" TabIndex="5"
                Text="Search" OnClick="btnSearch1_Click1" />                        
						</div>
                             <div class="col-md-6"> 
                                 <span id="spanPatInfoID" runat="server" style="display:none;"></span>
            &nbsp; &nbsp;       </div>
                              <div class="col-md-6"> 
                    </div>
					
						
                </div>
                              </div>
                
            
            <div class="POuter_Box_Inventory" style="text-align: center">
                  <div class="row">
                    <div class="col-md-24">
                <asp:GridView ID="grdPhysical" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("ReportingPersonName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit2" AlternateText="Edit" CausesValidation="false" CommandName='Print' CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                        </div>
                      </div>
            </div>
            

</asp:Content>

