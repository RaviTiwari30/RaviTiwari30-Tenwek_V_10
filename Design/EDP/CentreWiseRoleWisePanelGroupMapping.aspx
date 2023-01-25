<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CentreWiseRoleWisePanelGroupMapping.aspx.cs" Inherits="Design_EDP_CentreWiseRoleWisePanelGroupMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        panelGroupList = [];

        var checkBoxListHTML = "";

        $(document).ready(function () {
            getAllCentre(function (centreID) {
                bindPanelGroup(function () {
                   // getMappings(centreID, function () {
                        if ($('#lblselectedcenterid').text() != '') {
                            $('#ddlCentre').val($('#lblselectedcenterid').text()).change().chosen("destroy").chosen();
                        }
                    //});
                });
            });
        });


        var bindPanelGroup = function (callback) {
            serverCall('Services/CentreWiseMapping.asmx/bindPanelGroup', {}, function (response) {
                panelGroupList = JSON.parse(response);
                callback();
            });
        }




        var onCentreChange = function () {
            var centreID = Number($('#ddlCentre').val());
            getMappings(centreID, function () {
                checkAlreadyMapped(function () { });
            });
        }
        var getMappings = function (centreID, callback) {
            data = {
                centreID: centreID,
                roleName: $('#txtSearch').val()
            }

            serverCall('Services/CentreWiseMapping.asmx/GetRoleWithPanelGroupMappings', data, function (response) {
                responseData = JSON.parse(response);

                var divRoleMapping = $('#divRoleMapping');
                var parseHTML = $('#templateMapping').parseTemplate(responseData);
                divRoleMapping.html(parseHTML).customFixedHeader();
                callback(responseData);
            });
        }



        var getAllCentre = function (callback) {
            serverCall('Services/CentreWiseMapping.asmx/GetAllCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlCentre = $('#ddlCentre');
                ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback(ddlCentre.val());
            });

        }

        var saveMappingDetails = function () {
            getMappingDetails(function (data) {
                serverCall('Services/CentreWiseMapping.asmx/SaveCentreWiseRoleWisePanelGroup', data, function (resposne) {
                    var responseData = JSON.parse(resposne);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }



        var checkAlreadyMapped = function () {

            $('#divRoleMapping').find('#tblRoleWithBillingType tbody tr').each(function (i, r) {
                // debugger;
                var rowId = $(this);
                var tdData = JSON.parse(rowId.find('#tdData').text());
                var PanelGroups = tdData.PanelGroupID.split(',');
                checkBoxList = rowId.find('input[type=checkbox][name=chkPanelGroup_' + tdData.ID + ']');
                $.each(PanelGroups, function (j, r) {
                    $.each(checkBoxList, function (k, r) {
                        var chkid = "#chkItem_" + $(checkBoxList[k]).val();

                        if ($(checkBoxList[k]).val() == PanelGroups[j])
                            $(rowId.find(chkid)).prop('checked', true);
                    });
                });
            });

        }
        var getMappingDetails = function (callback) {

            //   debugger;

            var centreID = Number($('#ddlCentre').val());
            var mappedRolesWisePanelGroup = [];
            $('#divRoleMapping').find('#tblRoleWithBillingType tbody tr').each(function (i, r) {
                var tdData = JSON.parse($(this).find('#tdData').text());
                var selectedPanelGroups = $(this).find('input[type=checkbox][name=chkPanelGroup_' + tdData.ID + ']:checked');

                var panelGroupIDs = "";
                if (selectedPanelGroups.length > 0) {
                    $.each(selectedPanelGroups, function (k, r) {

                        if (panelGroupIDs == "")
                            panelGroupIDs = $(selectedPanelGroups[k]).val();
                        else
                            panelGroupIDs = panelGroupIDs + "," + $(selectedPanelGroups[k]).val();
                    });
                }
                mappedRolesWisePanelGroup.push({
                        centreID: centreID,
                        roleID: tdData.ID,
                        PanelGroupIDs: panelGroupIDs
                    });
            });

            callback({ centreID: centreID, MappedRolesWisePanelGroup: mappedRolesWisePanelGroup });
        }

        var onSelectElem = function (el) {
           if ($(el).is(':checked'))
              $('.'+$(el).val()).prop('checked', true);
            else
               $('.' + $(el).val()).prop('checked', false);
        }

    </script>
    

    <script id="templateMapping" type="text/html">


       <table class="FixedTables" cellspacing="0" width="100%" rules="all" border="1" id="tblRoleWithBillingType" style="width:100%;border-collapse:collapse;">
		<#if(responseData.length>0){#>
		    <thead>
                <tr  id='Header'>
                    <th class='GridViewHeaderStyle'>S.No.</th>
                    <th class='GridViewHeaderStyle'>Role Name</th>
                    <th class='GridViewHeaderStyle' style="display:none;">Mapped Panel Group </th>
                    <th class='GridViewHeaderStyle'>Map Panel Group <br />
                        <hr  style="width:100%; height:2px; background-color:white;" />
                         <label class="pull-center" style="font-size:8.75pt; font-weight:normal">
                             <#
                              for(var a=0;a<panelGroupList.length;a++)
		                        {
		                          #>
                                 <input id='chkHeader_<#=panelGroupList[a].PanelGroupID#>' type="checkbox" name='chkPanelGroup_Header' onchange="onSelectElem(this)" value='<#=panelGroupList[a].PanelGroupID#>'/>
                                <label for='chkHeader_<#=panelGroupList[a].PanelGroupID#>'><#=panelGroupList[a].PanelGroup#></label>
                                  <#}#>
                         </label>
                        <br />
                    </th>
                </tr>
		    </thead>
		 <#}#>
		    <tbody>

		    <#

		    var dataLength=responseData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;   
		    var status;
		    for(var j=0;j<dataLength;j++)
		    {
                
		    objRow = responseData[j];
		
		      #>
                <tr class="trRoleList" <# if(objRow.PanelGroupID !='') {#> style="background-color:lightgreen"  <#}#> >
                    <td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                    <td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
                    <td id="tdRoleName" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.RoleName#></td>
			        <td id="tdBillingType" class="GridViewLabItemStyle" style="text-align:center; display:none;"><#=objRow.PanelGroup#></td>
	    		    <td id="tdBillingTypeNew" class="GridViewLabItemStyle" style="text-align:center;">
                         <label class="pull-center" >
                             <# for(var a=0;a<panelGroupList.length;a++) { #>
                                 <input id='chkItem_<#=panelGroupList[a].PanelGroupID#>' class='<#=panelGroupList[a].PanelGroupID#>' type="checkbox" name='chkPanelGroup_<#=objRow.ID#>' value='<#=panelGroupList[a].PanelGroupID#>' 
                                      
                                      />
                                <label for='chkItem_<#=panelGroupList[a].PanelGroupID#>'><#=panelGroupList[a].PanelGroup#></label>
                                  <#}#>
                         </label>
	    		    </td>
				</tr>   

			<#}#>
        </tbody>
	 </table>    
	</script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b><span id="lblHeader bold">CentreWise Role Wise Panel Group Mapping</span></b>
            <span class="hidden" id="spnHashCode"></span>
            <asp:Label ID="lblselectedcenterid" runat="server" ClientIDMode="Static" style=" display:none;"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                select Centre
            </div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-8">
                            <select id="ddlCentre" onchange="onCentreChange();"></select>
                        </div>


                        <div class="col-md-3">
                            <label class="pull-left">
                                Role Name
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-7">
                            <input type="text" id="txtSearch" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnSearch" value="Search" class="save margin-top-on-btn" onclick="onCentreChange()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>


        <div class="POuter_Box_Inventory" style="padding-bottom: 0px;">

            <div class="row" style="margin: 0px;">
                <div class="Purchaseheader">
                    Role-Wise Billing Type Mapping List
                </div>
                <div id="divRoleMapping" style="max-height: 425px; overflow: auto;"></div>
            </div>

        </div>


        <div class="POuter_Box_Inventory textCenter">
            <input type="button" id="btnSave" value="Save" class="save margin-top-on-btn" onclick="saveMappingDetails(this)" />
        </div>


    </div>

</asp:Content>

