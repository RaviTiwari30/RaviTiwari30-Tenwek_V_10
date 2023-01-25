<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OnlineRadiologyResultEntry.aspx.cs" Inherits="Design_Lab_OnlineRadiologyResultEntry" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <title></title>
    <style type="text/css">
        .Approved {
        background-color:#90EE90;
        }
        .RowStyle {
                  height: 100px;
                }
    </style>
    


    
  
    <link href="Style/ResultEntryCSS.css" rel="stylesheet" />
    

    <script type="text/javascript">
        function save() {
            var testid = localStorage.getItem("testid");
            var reporttype = '3';
            var description = CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].getData();
            var findingvalue = '10';
            var method = '1';
            $.ajax({
                url: "OnlineRadiologyResultEntry.aspx/SaveLabObservationOpdData",
                data: JSON.stringify({ testid: testid, reporttype: reporttype, description: description, findingvalue: findingvalue, method: method }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    if (result.d == "success") {
                        $("#divEditor").hide();
                        modelAlert("Record Saved Successfully");
                       // $("#divModal").show();
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                   }
            });

        }
        function showEditor() {
            $("#divEditor").show();
        }
        function closeEditor() {
            //alert();
            $("#divEditor").hide();
        }


        $(document).ready(function () {
            $("#txtUHID").val('');
            var isvalid = '<%=isvalid  %>';
            //alert(uhid);
            if (isvalid == "1") {

                $("#Pbody_box_inventory").show();
                //$("#divValidate").show();
            }
            else {

            }
        });

        function validate() {
            var center = $('#<%=ddlCenterMaster.ClientID %>').val();
            var un = $('#<%=txtUserName.ClientID %>').val();
            var pwd = $('#<%=txtPassword.ClientID %>').val();

            if (un == "") {
                $("#spanMsg").text("Please enter UserName.");
                $("#divModal").show();
                location.reload();
                }

            if (pwd == "") {

                $("#spanMsg").text("Please enter Password.");
                $("#divModal").show();
                location.reload();
                }

            jQuery.ajax({
                type: "POST",
                url: "OnlineRadiologyResultEntry.aspx/UserLogin",
                data: '{center:"' + center + '",username:"' + un + '",password:"' + pwd + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    //alert(response.d);
                    if (response.d == "1") {
                        $("#txtV").val("1");
                        $("#divUHID").show();
                    }
                    else {

                        $("#txtV").val("0");
                        location.reload();

                    }
                },
                error: function (xhr, status) {

                }
            });
        }

        function getDescription(tid) {
            if (tid != "") {
                jQuery.ajax({
                    type: "POST",
                    url: "OnlineRadiologyResultEntry.aspx/GetDescription",
                    data: '{testid:"' + tid + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    success: function (response) {
                        if (response.d != "0") {

                            CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(response.d);
                        }
                        else {
                            CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData('');
                        }

                    },
                    error: function (xhr, status) {

                    }
                });
            }
        }
        function show(id) {
            var status = $(id).siblings(".status").text();
            var testid = $(id).siblings(".testid").text();
            var testname = $(id).siblings(".testname").text();
            $("#spanTestID").text(testid);
            $("#spanTestName").text(testname);
            localStorage.setItem("testid", testid);
            //alert(status);
            
                    window.open('printLabReport_pdf.aspx?TestID=' + testid + '&LabType=&LabreportType=11');
                

            
        }
        function show1(id) {
            var status = $(id).siblings(".status").text();
            var testid = $(id).siblings(".testid").text();
            var testname = $(id).siblings(".testname").text();
            $("#spanTestID").text(testid);
            $("#spanTestName").text(testname);
            localStorage.setItem("testid", testid);
            //alert(status);
                getDescription(testid);
                $("#divEditor").show();
            
        }
    </script>

         <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Investigation Details</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b  class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" CssClass="" autocomplete="off"  />
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server"  autocomplete="off" CssClass="save" Text="Search" ClientIDMode="Static" OnClick="btnSearch_Click" /> 
            
                        </div>
                    </div>
                </div>
            </div>
        </div>
             <div class="POuter_Box_Inventory textCenter">
           
            <div class="row" style="margin-left:300px;">
                <center>
                    <div class="col-md-25">
                        
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Received" onclick="statusbuttonsearch('Pending')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Pending</b>
                                 <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Tested" onclick="statusbuttonsearch('Tested')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Tested</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Forwarded" onclick="statusbuttonsearch('Forwarded')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Forwarded</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Approved" onclick="statusbuttonsearch('Approved')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Approved</b>
                       <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Printed" onclick="statusbuttonsearch('Printed')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Printed</b>
                     <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Hold" onclick="statusbuttonsearch('Hold')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Hold</b>
                      <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle Rejected" onclick="statusbuttonsearch('Rejected Sample')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Rejected</b>
 
                    </div>
                </center>
            </div>
        </div>
             <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Result
                </div>
                <div style="height:340px;overflow:auto;">
                    <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass='GridViewStyle <%#Eval("Status") %>' ClientIDMode="Static"  OnRowDataBound="grdLabSearch_RowDataBound"
                           Width="100%">
                        <RowStyle Height="25px" />
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="25px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                              
                            <asp:TemplateField HeaderText="PatientType">
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientaType" ClientIDMode="Static" runat="server" Text=' <%#Eval("PatientType") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BarcodeNo">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblBarcodeNo" ClientIDMode="Static" runat="server" Text='<%# Eval("BarcodeNo") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PatientID">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="50px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" HorizontalAlign="Right" />
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" runat="server" ClientIDMode="Static" Text='<%#Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Pat. Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="145px" />
                                <ItemTemplate>
                                    <%#Eval("PName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age_Gender">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                <ItemTemplate>
                                    <%#Eval("Age_Gender") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <%#Eval("Status") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="InvestigationName">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                <ItemTemplate>
                                    <%#Eval("InvestigationName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="DATE">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" runat="server" ClientIDMode="Static" Text='<%#Eval("DATE") %>' ></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Select">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>
                                    
                                    <asp:Label ID="lblStatus" runat="server" Visible="false" ClientIDMode="Static" Text='<%#Eval("Status") %>' ></asp:Label>
                                    <span class="testid" style="display:none" ><%#Eval("Test_ID") %></span>
                                       <span class="testname" style="display:none" ><%#Eval("InvestigationName") %></span>
                                    <span class="status" style="display:none;"><%#Eval("Status1") %></span>
                                  <div id="spanStatus1" runat="server"  onclick="show1(this);"  style="display:inline-block;margin:2px;padding:2px;"  ><img id="img1" runat="server" src="../../Images/post.GIF" value='<%#Eval("Status1") %>' /></div>
                                     
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Preview">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    
                                    <asp:Label ID="lblStatus1" runat="server" Visible="false" ClientIDMode="Static" Text='<%#Eval("Status") %>' ></asp:Label>
                                    <span class="testid" style="display:none" ><%#Eval("Test_ID") %></span>
                                       <span class="testname" style="display:none" ><%#Eval("InvestigationName") %></span>
                                    <span class="status" style="display:none;"><%#Eval("Status1") %></span>
                                     <div id="spanStatus" runat="server"  onclick="show(this);" style="display:inline-block;margin:2px;"  ><img id="imgstatus" runat="server" src="../../Images/view.GIF" value='<%#Eval("Status1") %>' /></div>
                                
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        
                    </asp:GridView>
                </div>
             
            </div>
        </asp:Panel>
             </div>
     
   
          <div id="divValidate" class="modal fade show">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <b class="modal-title">Validate User</b>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <table >
                                            <tr style="text-align:center"><td style="text-align:center"></td>
					                              <asp:Label ID="lblError" runat="server" Visible="False" ForeColor="Red"
			                               EnableViewState="False" meta:resourcekey="lblErrorResource1"></asp:Label>
				                            </tr>
                                            <tr><td><b>Centre Name</b></td><td><asp:DropDownList ID="ddlCenterMaster" runat="server" CssClass="selectbox"></asp:DropDownList></td>
					                        </tr>

					                        <tr><td><b>User Name</b></td><td><input type="hidden" id="txtV" class="textbox" value="0" /><asp:TextBox ID="txtUserName"   autocomplete="off" runat ="server" CssClass="textbox" meta:resourcekey="txtUserNameResource1"  AutoCompleteType="Disabled"></asp:TextBox></td></tr>
					                        <tr><td ><b>Password</b></td><td><asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password"  autocomplete="off" meta:resourcekey="txtPasswordResource1" AutoCompleteType="Disabled"></asp:TextBox></td></tr>
					                        <tr><td colspan="2">
                                                <button id="btnValidate" class="btn" onclick="validate();">Validate</button>
							                        <asp:Button ID="btnCancel" runat="server" CssClass="btn cancelbtn" Text="Clear" OnClick="btnCancel_Click"   /></td></tr>
				                           </table>
                                
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
    <div id="divEditor" class="modal fade">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <b class="modal-title"></b> <button type="button" class="close"  onclick="closeEditor();">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    
                                    <div class="col-md-2" style="text-align: center;display:none">
                                       <b> Test ID:</b>
                                        </div>
                                    <div class="col-md-2" style="text-align: center; display:none">
                                        <span id="spanTestID"></span>
                                        </div>
                                    
                                    
                                    <div class="col-md-3" style="text-align: center;">
                                        <b>Test Name:</b>
                                        </div>
                                    
                                    <div class="col-md-8" style="text-align: center;">
                                        <span id="spanTestName"></span>
                                        </div>
                                    </div>
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <br />
                                        <CKEditor:CKEditorControl ID="CKEditorControl2" BasePath="~/ckeditor" runat="server" Height="180" ></CKEditor:CKEditorControl>
                    
                                    </div>
                                </div>
                                    <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                <input id="btnSaveLabObs" type="button" value="Save" class="ItDoseButton btnForSearch demo SampleStatus" onclick="save();" style="width:auto;height:25px;" />  
                            </div>
                                        </div>
                                    </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
      <div id="divModal" class="modal fade">
                    <div class="modal-dialog modal-sm"" >
                        <div class="modal-content">
                            <div class="modal-header">
                                <b class="modal-title">Success Message</b> <button type="button" class="close"  onclick="$('#divModal').hide();">&times;</button>
                            </div>
                            <div class="modal-body"  style="width:200px;height:60px;">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <span id="spanMsg"></span><br /><br />
                                        <button type="button"  onclick="$('#divModal').hide();">OK</button>
                                    </div>
                                </div>
                                                                        </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
 
</asp:Content>