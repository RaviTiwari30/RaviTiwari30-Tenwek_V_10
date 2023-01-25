<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PublicHolidays.aspx.cs" Inherits="Design_EDP_PublicHolidays" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Public Holidays Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />&nbsp;              
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Holiday Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlHoliday"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select Date" TabIndex="5"></asp:TextBox>
                    <cc1:CalendarExtender ID="caltxtDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <input type="button" onclick="saveHolidaysDetails(1, 0,0);" value="Save" />
                </div>
                <div class="col-md-8">
                    <input type="button" onclick="openCreateAndDeactivePopup();" value="Create & De-Active(Selected) Holidays" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;" runat="server">
            <div class="Purchaseheader">Holidays Details</div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdfrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <input type="button" onclick="bindHolidaysSearch()" style="width: 100px;" value="Search" />
                </div>
                <div class="col-md-5">
                </div>
            </div>
            <div class="row">
                <div id="dvHolidaysDetails"></div>
            </div>
        </div>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblHolidaysId" Style="display: none"></asp:Label>

        <div id="dvCreateAndDeactiveHolidays" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 40%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeCreateAndDeactiveHolidayModel()" aria-hidden="true">×</button>
                        <h4 class="modal-title"><span id="spnHeaderLabel">Create New Holidays</span> </h4>
                    </div>
                    <div style="max-height: 200px; overflow: auto;" class="modal-body">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-7">
                                <label class="pull-left">
                                    Holiday Name 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-15">
                                <input type="text" id="txtHolidayName" class="requiredField" maxlength="100" />
                            </div>
                            <div class="col-md-1"></div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnSaveHoliday" onclick="onSaveHolidays(1)">Save</button>
                        <button type="button" id="btnDeActive" onclick="onDeActiveHolidays()">De-Active</button>
                        <button type="button" onclick="closeCreateAndDeactiveHolidayModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            bindHoliday(function () {
                bindHolidaysSearch(function () { });
            });
        });

        var bindHoliday = function (callback) {
            var $ddlHoliday = $('#ddlHoliday');
            serverCall('PublicHolidays.aspx/bindHolidayName', {}, function (response) {
                $ddlHoliday.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'HolidaysName', isSearchAble: true });
                callback($ddlHoliday.val());

            });
        }

        var bindHolidaysSearch = function () {
            // debugger;
            data = {
                fromDate: $("#txtFromDate").val(),
                toDate: $("#txtToDate").val()
            }
            serverCall('PublicHolidays.aspx/bindHolidaysSearch', data, function (response) {
                HolidayData = JSON.parse(response);
                var message = $('#tb_Holidays').parseTemplate(HolidayData);
                $('#dvHolidaysDetails').html(message);
            });
        }
        var closeCreateAndDeactiveHolidayModel = function () {
            $('#dvCreateAndDeactiveHolidays').closeModel();
        }

        var openCreateAndDeactivePopup = function () {

            if ($("#ddlHoliday").val() != "0") {
                $("#lblHolidaysId").text($("#ddlHoliday").val());
                $("#btnSaveHoliday").hide();
                $("#btnDeActive").show();
                $("#txtHolidayName").val($("#ddlHoliday option:selected").text()).attr('disabled', true);
                $("#spnHeaderLabel").text("De-Active Selected Holidays");
            }
            else {
                $("#lblHolidaysId").text("");
                $("#btnSaveHoliday").show();
                $("#btnDeActive").hide();
                $("#txtHolidayName").val("").attr('disabled', false);
                $("#spnHeaderLabel").text("Create New Holidays");
            }
            $('#dvCreateAndDeactiveHolidays').showModel();
        }

        var onDeActiveHolidays = function () {
            modelConfirmation('Are You Sure ?', 'To De-Active the Selected Holidays', 'Yes', 'No', function (res) {
                if (res) {
                    onSaveHolidays(2);
                }
            });
        }
        var onSaveHolidays = function (type) {
            if (type == 1) {
                if ($("#txtHolidayName").val() == "") {
                    $("#txtHolidayName").focus();
                    return;
                }
            }

            data = {
                type: type,
                holidaysId: $("#lblHolidaysId").text(),
                holidaysName: $("#txtHolidayName").val()
            }
            serverCall('PublicHolidays.aspx/SaveHolidays', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        bindHoliday(function () {
                            $('#dvCreateAndDeactiveHolidays').hideModel();
                        });
                    });
                }
                else
                    modelAlert(responseData.response);
            });
        }

        var onUpdateActiveHolidays = function (id) {

            modelConfirmation('Are You Sure ?', 'To Delete the Selected Holiday Entry', 'Yes', 'No', function (res) {
                if (res) {
                     saveHolidaysDetails(2, id,0);
                }
            });
        }

        var saveHolidaysDetails = function (Type, Id, IsSkipValidation) {
            $("#lblMsg").text("");
            if (Type == 1)
            {
                if ($("#ddlHoliday").val() == "0")
                {
                    $("#lblMsg").text("Please Select Holiday Name");
                    $("#ddlHoliday").focus();
                    return;
                }
                if ($("#txtDate").val() == "") {
                    $("#lblMsg").text("Please Enter Date");
                    $("#txtDate").focus();
                    return;
                }
            }
            data = {
                type: Type,
                id: Id,
                holidaysId: Number($("#ddlHoliday").val()) ,
                holidaysName: $("#ddlHoliday option:selected").text() ,
                HolidayDate: $("#txtDate").val(),
                isSkipValidation: IsSkipValidation
            }
            serverCall('PublicHolidays.aspx/saveHolidaysDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.IsConfirm == 1) {
                        modelConfirmation('Are You Sure To Save Forcefully ?', responseData.response, 'Yes', 'No', function (res) {
                            if (res) {
                                saveHolidaysDetails(Type, Id, 1);
                            }
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {
                            bindHolidaysSearch(function () { });
                        });
                    }
                }
                else
                    modelAlert(responseData.response);
            });
        }

    </script>
     <script id="tb_Holidays" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdHolidays" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Holidays Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Holidays Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Delete</th> 
            </tr>
                </thead><tbody>
        <#       
        var dataLength=HolidayData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = HolidayData[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center; width:25px;"><#=j+1#></td>
                   <td class="GridViewLabItemStyle" style="text-align:left;width:200px;"><#=objRow.HolidaysName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;width:200px;"><#=objRow.HolidaysDate #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:115px;"><#=objRow.EmployeeName #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center; width:200px;"><#=objRow.EntryDate #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center; width:25px;">
                    <#if(objRow.IsDeactiveHolidays=="1"){#>
					     <img alt="Delete" id="imgDelete" title="Delete" onclick="onUpdateActiveHolidays('<#=objRow.ID #>')" src="../../Images/Delete.gif" />
				    <#}#>
                   </td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>

</asp:Content>
