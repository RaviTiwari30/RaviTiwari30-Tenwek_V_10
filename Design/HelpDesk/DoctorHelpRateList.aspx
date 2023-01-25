<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorHelpRateList.aspx.cs" Inherits="Design_HelpDesk_DoctorHelpRateList"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


 <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
                <script type="text/javascript" src="../../Scripts/Message.js"></script>

      <script type="text/javascript" >
          function showDoctor() {
              $("#lblMsg").text('');
              $.ajax({
                  type: "POST",
                  url: "Services/HelpDesk.asmx/showHelpdeskDoctor",
                  data: '{Department:"' + $("#ddlDepartment").val() + '",DName:"' + $("#txtName").val() + '",Specialization:"' + $("#ddlSpecialization option:selected").text() + '"}',
                  dataType: "json",
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                      doc = jQuery.parseJSON(response.d);
                      if (doc != null) {
                          var output = $('#tb_doctor').parseTemplate(doc);
                          $('#doctorOutput').html(output);
                          $('#doctorOutput').show();
                      }
                      else {
                          DisplayMsg('MM04', 'lblMsg');
                          $('#doctorOutput').hide();
                      }
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblMsg');
                  }

              });
          }
          function viewDocRate(rowid) {
              var DID = $(rowid).closest('tr').find('#tdDoctorID').text();
              var DName = $(rowid).closest('tr').find('#tdName').text();
              $("#lblDoctorName").text(DName);
              $("#lblDoctorID").text(DID);
              $('#cmbCaseType').prop('selectedIndex', 0);
              $find('mopRateType').show();
          }

          

          function viewDoctorRate() {
              var Type; var Reference;
              if ($("#rblOPD").is(':checked')) {
                  Type = "OPD";
                  Reference = $("#ddlPanel").val().split('#')[2]; 
              }
              else {
                  Type = "IPD";
                  Reference = $("#ddlPanel").val().split('#')[1];
              }
              $.ajax({
                  type: "POST",
                  url: "Services/HelpDesk.asmx/viewDoctorRate",
                  data: '{Type:"' + Type + '",DoctorID:"' + $("#lblDoctorID").text() + '",Reference:"' + Reference + '",SubCategory:"' + $("#cmbSubCategory").val() + '",CaseType:"' + $("#cmbCaseType").val() + '",ScheduleChargeID:"' + $("#ddlScheduleCharge").val() + '"}',
                  dataType: "json",
                  contentType: "application/json;charset=UTF-8",
                  async: false,
                  success: function (response) {
                      doctor = jQuery.parseJSON(response.d);
                      if (doctor != null) {
                          var output = $('#tb_doctorRate').parseTemplate(doctor);
                          $('#doctorRateOutput').html(output);
                          $('#doctorRateOutput').show();
                      }
                      else {
                          $('#doctorRateOutput').hide();
                      }
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblMsg');
                  }

              });
          }
          function pageLoad(sender, args) {
              if (!args.get_isPartialLoad()) {
                  $addHandler(document, "keydown", onKeyDown);
              }
          }
          function onKeyDown(e) {
              if (e && e.keyCode == Sys.UI.Key.esc) {
                  if ($find("mopRateType")) {
                      $find('mopRateType').hide();
                      blankDocRate();
                  }
              }
          }

          function blankDocRate() {
              $("#rblIPD").attr("checked", "checked");
              $('#doctorRateOutput').hide();
              $('#ddlPanel').prop('selectedIndex', 0);
              BindScheduleChage();
              bindIPD();
              $('#cmbCaseType').prop('selectedIndex', 0);
          }
          function bindOPD() {

              $('#cmbCaseType').hide();

              $('#lblCaseType').hide();
              $('#doctorRateOutput').hide();
          }

          function bindIPD() {
              $('#ddlPanel').show();
              $('#cmbCaseType').show();
              $('#lblPanel').show();
              $('#lblCaseType').show();
              $('#doctorRateOutput').hide();
          }
          function BindScheduleChage() {
              var PanelID;
              if ($("#rblOPD").is(':checked')) {
                  PanelID = $("#ddlPanel").val().split('#')[1];
              }
              else {
                  PanelID = $("#ddlPanel").val().split('#')[2];
              }              
              var ScheduleCharge = $("#ddlScheduleCharge");
              $("#ddlScheduleCharge option").remove();
              $.ajax({
                  url: "Services/HelpDesk.asmx/BindScheduleChage",
                  data: '{ PanelID: "' + PanelID + '"}', // parameter map
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  async: false,
                  dataType: "json",
                  success: function (result) {
                      Schedule = jQuery.parseJSON(result.d);

                      if (Schedule.length == 0) {
                          ScheduleCharge.append($("<option></option>").val("0").html("---No Data Found---"));
                      }
                      else {
                          for (i = 0; i < Schedule.length; i++) {
                              ScheduleCharge.append($("<option></option>").val(Schedule[i].ScheduleChargeID).html(Schedule[i].NAME));
                         }
                      }
                      ScheduleCharge.attr("disabled", false);
                  },
                  error: function (xhr, status) {
                      DisplayMsg('MM05', 'lblMsg');
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
          }
          $(document).ready(function () {
              BindScheduleChage();
          });
          </script>
  <div id="Pbody_box_inventory" >
  <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align:center;">
   
    <b>
        Doctor Rate List</b><br />

  <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                                                
    
    </div> 
    <div class="POuter_Box_Inventory" style="text-align: center; ">
    <div class="Purchaseheader" >
        Search Criteria</div>
                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                            <tr >
                                <td style="width: 20%; text-align:right" >
                                Name :&nbsp;    
                                   
                                    </td>
                                <td style="width: 30%; text-align: left; ">
                                  <asp:TextBox ID="txtName" runat="server" Width="150px" TabIndex="1" ClientIDMode="Static"  MaxLength="30"></asp:TextBox></td>

                                    
                               
                                <td style="width: 20%; text-align:right" >
                                  
                                </td>
                                <td style="width: 30%; text-align: left;"></td>
                            </tr>
                           <tr >
                                <td style="width: 20%; text-align:right" >
                                    Department :&nbsp;
                                    </td>
                                <td style="width: 30%; text-align: left; ">
                                    <asp:DropDownList ID="ddlDepartment" Width="156px" runat="server" TabIndex="2" ClientIDMode="Static"></asp:DropDownList>

                                    </td>
                                <td style="width: 20%; text-align:right" >
                                    Specialization :&nbsp;
                                     </td>
                                <td style="width: 30%; text-align: left;">
                                    <asp:DropDownList ID="ddlSpecialization" Width="156px" runat="server" TabIndex="3" ClientIDMode="Static"></asp:DropDownList>

                                    </td>
                               </tr>
                            <tr >
                                <td  style="text-align:center" colspan="4">
                                            
                                    <input type ="button" value="Search" onclick="showDoctor()" tabindex="4" class="ItDoseButton" />
                                </td>
                            </tr>
                        </table>
    </div> 
     <div class="POuter_Box_Inventory" >
    <div class="Purchaseheader" >
        Search Result</div>
   
         <table style="width:100%">
                <tr>
                    <td style="text-align:center"  colspan="5">

                        <div id="doctorOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>

                    </td>

                </tr>
           </table>
       
    
    
   </div>
    
    
     <asp:Button ID="btnDocRate" runat="server"  Style="display:none" CssClass="ItDoseButton"/>
      <cc1:ModalPopupExtender ID="mopRateType" runat="server" CancelControlID="imgCloseButton"
          DropShadow="true" TargetControlID="btnDocRate" OnCancelScript="blankDocRate()"
          BackgroundCssClass="filterPupupBackground" PopupControlID="PnlRateType"
          BehaviorID="mopRateType" PopupDragHandleControlID="Div3">
      </cc1:ModalPopupExtender>
      <asp:Panel ID="PnlRateType" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; height: 380px; overflow-x: auto;"
          Width="600px">
          <div class="Purchaseheader" id="Div4" runat="server">
              Rate Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <span style="font-size: 11px">Press esc or click
                                <asp:ImageButton ID="imgCloseButton" runat="server" ClientIDMode="Static" ImageUrl="~/Images/Delete.gif" />
                   to close</span>
          </div>

          <table>
              <tr>
                  <td colspan="2">
                      <asp:RadioButton ID="rblOPD" ClientIDMode="Static" runat="server" GroupName="a" Text="OPD" onclick="bindOPD()" />
                      <asp:RadioButton ID="rblIPD" ClientIDMode="Static" runat="server" GroupName="a" Text="IPD" Checked="True" onclick="bindIPD()" />

                  </td>
              </tr>
              <tr style="display: none">
                  <td>
                      <asp:Label ID="lblSubCat" ClientIDMode="Static" runat="server" Text="SubCategory : " Style="display: none" CssClass="ItDoseLabel"></asp:Label>
                  </td>
                  <td>
                      <asp:DropDownList ID="cmbSubCategory" runat="server" ClientIDMode="Static"
                          Style="display: none" Width="256px" ToolTip="Select Sub Category">
                      </asp:DropDownList>
                  </td>
              </tr>
              <tr>
                  <td style="text-align: right">Doctor Name :&nbsp;
                  </td>
                  <td>
                      <asp:Label ID="lblDoctorName" runat="server"
                          ClientIDMode="Static">
                      </asp:Label>
                      <asp:Label ID="lblDoctorID" runat="server" Style="display: none"
                          ClientIDMode="Static">
                      </asp:Label>

                  </td>
              </tr>
              <tr>
                  <td style="text-align: right">
                      <asp:Label ID="lblPanel" runat="server" Text="Panel :&nbsp;" ClientIDMode="Static"></asp:Label>
                  </td>
                  <td>
                      <asp:DropDownList ID="ddlPanel" Width="220px" runat="server" ClientIDMode="Static" onchange="BindScheduleChage()">
                      </asp:DropDownList>
                  </td>
              </tr>
              <tr>
                  <td style="text-align: right">Schedule&nbsp;Charges :
                  </td>
                  <td>
                      <asp:DropDownList ID="ddlScheduleCharge" runat="server"
                          Width="220px" AppendDataBoundItems="True" ClientIDMode="Static"
                          ToolTip="Select Schedule Charges">
                      </asp:DropDownList>
                  </td>
              </tr>
              <tr>
                  <td style="text-align: right; vertical-align: top">
                      <asp:Label ID="lblCaseType" Style="vertical-align: top" runat="server" Text="CaseType :&nbsp;" ClientIDMode="Static"></asp:Label>
                  </td>
                  <td>
                      <asp:ListBox ID="cmbCaseType" Width="220px" ClientIDMode="Static" runat="server" SelectionMode="Multiple"></asp:ListBox>
                  </td>
              </tr>
              <tr>
                  <td style="text-align: center" colspan="2">
                      <input type="button" value="View" class="ItDoseButton" onclick="viewDoctorRate()" />
                  </td>
              </tr>
              <tr>
                  <td colspan="2">
                      <table style="width: 580px">
                          <tr>
                              <td style="text-align: center">

                                  <div id="doctorRateOutput" style="max-height: 200px; overflow-x: auto;">
                                  </div>

                              </td>

                          </tr>
                      </table>
                  </td>
              </tr>

          </table>

      </asp:Panel>
      </div>
            <script id="tb_doctor" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:954px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Specialization</th>
           	 <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none"></th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Rate</th>           
		</tr>
        <#       
        var dataLength=doc.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = doc[j];
        #>
            

                    <tr id="<#=j+1#>" 
                        >                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdName"  style="width:240px;text-align:center" ><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdDepartment"  style="width:140px;text-align:center" ><#=objRow.Department#></td>
                    <td class="GridViewLabItemStyle" id="tdSpecialization"  style="width:140px;text-align:center" ><#=objRow.Specialization#></td>
                   <td class="GridViewLabItemStyle" id="tdDoctorID"  style="width:100px;text-align:center;display:none" ><#=objRow.DID#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;">
                         <input type ="button" value="Rate" class="ItDoseButton" onclick="viewDocRate(this)" />                                                                                       
                       
                    </td>                    
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

    <script id="tb_doctorRate" type="text/html">
    <table  cellspacing="0"  border="1" 
    style="width:584px;border-collapse:collapse;">
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:450px;">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Rate</th>
                    
		</tr>
        <#       
        var dataLength=doctor.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = doctor[j];
        #>
            

                     <tr id="<#=j+1#>"  > 
                                                   
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName"  style="width:450px;text-align:center" ><#=objRow.name#></td>
                    <td class="GridViewLabItemStyle" id="tdrate"  style="width:90px;text-align:center" ><#=objRow.Rate#></td>
                                   
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

    
    </asp:Content>
