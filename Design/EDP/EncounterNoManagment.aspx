<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EncounterNoManagment.aspx.cs" Inherits="Design_EDP_EncounterNoManagment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <link href="../../Styles/grid24.css" rel="stylesheet" />
    <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>


     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Encounter No. Managment</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>       
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                 <div class="row"> 
                        <div class="col-md-3">
                             <label class="pull-left">UHID</label>
			                   <b class="pull-right">:</b>	
                         </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUhid"  />
                        </div>
                        <div class="col-md-3">
                              <label class="pull-left">From Date</label>
			                   <b class="pull-right">:</b>												
						</div>
						<div class="col-md-5">
								<asp:TextBox ID="txtSearchFromDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">To Date</label>
			                   <b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <asp:TextBox ID="txtSearchToDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select To Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>                       
                    </div>
                   <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">Encounter No.</label>
			                   <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input type="text" id="txtEncounterNo" />
                        </div>
                   </div>
                </div>
                <div class="col-md-1"></div>
              </div>
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">
                 <div class="row">                
                     <div class="col-md-24">
                        <input type="button" id="btnSearch" value="Search" onclick="Search()" />
                     </div>
                </div>
            </div>
         <div class="POuter_Box_Inventory" style="text-align: left">
            &nbsp; Note : The following things should be noted.
            :--<br />
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1) If you want to open or close the patient encounter then you have to search the patient by UHID. 
            <br />
             &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2) If you search the list using date range you will get the list of encounter no. only with its staus.
            <br /> 
             &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3) You can take the action (open/close) only with the most recent encounter no. of the patient.
            <br />    
             &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4) You can not reopen the encounter of smartcard patient once close it.
            <br />         
        </div>
         <div id="EncDetailsTable" style="display:none">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row ">                
                    <div class="col-md-24" id="divList" style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" id="tblEncounterNo" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SN.</th>

                                    <th class="GridViewHeaderStyle">UHID</th>

                                    <th class="GridViewHeaderStyle">Name</th>

                                    <th class="GridViewHeaderStyle">Age</th>

                                    <th class="GridViewHeaderStyle">Gender</th>

                                    <th class="GridViewHeaderStyle">Encounter No</th>

                                    <th class="GridViewHeaderStyle">Status</th>
                                    
                                    <th class="GridViewHeaderStyle">Is Smart Card</th>

                                    <th class="GridViewHeaderStyle">Date</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Action</th>

                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                  </div>
                </div>
             </div>
        </div>

    <script type="text/javascript">
        $(document).ready(function () {

            // Search();

        });

        function Search() {
            var uhid = $("#txtUhid").val();          
            var EncounterNo = $("#txtEncounterNo").val();
            var fromdate = $('#<%=txtSearchFromDate.ClientID %>').val();
            var todate = $('#<%=txtSearchToDate.ClientID %>').val();
            
            if ((uhid == "" || uhid == undefined || uhid == null) && (fromdate == "" || fromdate == undefined || fromdate == null) && (todate == "" || todate == undefined || todate == null) && (EncounterNo == "" || EncounterNo == undefined || EncounterNo == null)) {
                modelAlert("Enter Any Search Criteria.");
                return false;
            }
            serverCall('EncounterNoManagment.aspx/GetDataToFill', { PatientId: uhid, FromDate: fromdate, ToDate: todate, EncounterNo: EncounterNo }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblEncounterNo tbody').empty();
                    $.each(data, function (i, item) {
                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.PatientId + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.NAME + '</td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblNewsDates">' + item.Age + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle">' + item.Sex + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.EncunterNo + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.STATUS + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.IsSmartCard + '</td>';                        
                        rdb += '<td class="GridViewItemStyle">' + item.EntryDate + '</td>';                        
                        if(uhid != "")
                        {
                            if (i == 0) {
                                if (item.IsActive == '1') {
                                    rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="Close" onclick="Close(' + item.EncounterId + ')"/></td>';

                                } else {
                                    if (item.IsSmartCard=='No') {
                                        rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="Open" onclick="Open(' + item.EncounterId + ')"/></td>';

                                    } else {
                                        rdb += '  <td class="GridViewItemStyle" > </td>'
                                    }
                                  
                                }
                            }
                            else {
                                rdb += '  <td class="GridViewItemStyle" > </td>'
                            }
                        }
                        else {
                            rdb += '  <td class="GridViewItemStyle" > </td>'
                        }
                     

                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblEncounterId">' + item.EncounterId + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle" style="display:none;"> <lable id="lblPatientId">' + item.PatientId + '</lable></td>';

                        rdb += '</tr> ';

                        $('#tblEncounterNo tbody').append(rdb);
                    });                  

                    $("#EncDetailsTable").show();
                    

                } else {
                    $("#EncDetailsTable").hide();
                    modelAlert(GetData.data);
                }

            });
        }



        function Close(CurrentId) {
            modelConfirmation('Are you sure ?', 'Do You Want to Close this Encounter No', 'Yes', 'No', function (status) {
                if (status == true) {
                    serverCall('EncounterNoManagment.aspx/Close', { Id: CurrentId }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                Search()
                            }
                        });
                    });

                } else {

                    return false;
                }


            });

        }


        function Open(CurrentId) {
            modelConfirmation('Are you sure ?', 'Do You Want to Open this Encounter No.', 'Yes', 'No', function (status) {
                if (status == true) {
                    serverCall('EncounterNoManagment.aspx/Open', { Id: CurrentId }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                Search();
                            }
                        });
                    });

                } else {

                    return false;
                }


            });

        }



    </script>







</asp:Content>
